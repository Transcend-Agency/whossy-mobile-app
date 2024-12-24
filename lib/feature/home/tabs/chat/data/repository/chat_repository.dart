import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whossy_app/common/utils/enum/enums.dart';

import '../../../matching/model/user_profile.dart';
import '../../model/chat.dart';
import '../../model/chat_with_user.dart';
import '../../model/current_chat.dart';
import '../../model/message.dart';
import '../../model/sub_chat.dart';
import '../source/extensions.dart';

class ChatRepository {
  final _chats = FirebaseFirestore.instance.collection('chats');
  final _users = FirebaseFirestore.instance.collection('users');

  CollectionReference<Map<String, dynamic>> _msgFirestore(String id) =>
      _chats.doc(id).collection('messages');

  Stream<UserProfile?> getChatterDataStream(String id) =>
      _users.doc(id).snapshots().map((docSnapshot) {
        if (docSnapshot.exists) {
          final data = docSnapshot.data();

          if (data != null) return UserProfile.fromJson(data);
        }

        return null;
      });

  void updateChatData({
    required Message message,
    required String chatId,
    required WriteBatch batch,
    required bool isConnected,
    required CurrentChat currentChat,
  }) {
    final updateData = Chat.updateChatData(
      message: message,
      isConnected: isConnected,
      currentChat: currentChat,
    );

    batch.set(_chats.doc(chatId), updateData, SetOptions(merge: true));
  }

  Future<void> updatePhotosData({
    required String chatId,
    required String docId,
    required Map<String, String> uploadResults,
  }) async {
    try {
      final msgRef = _msgFirestore(chatId).doc(docId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(msgRef);
        if (!snapshot.exists) return;

        final message = Message.fromJson(snapshot.data()!);

        String? localPhoto = message.localPhoto;
        String? photo = message.photo;

        uploadResults.forEach((localPath, downloadUrl) {
          if (localPhoto == localPath) {
            photo = downloadUrl;
          }
        });

        final updatedData = {
          'local_photo': FieldValue.delete(),
          'photo': photo,
        };

        transaction.update(msgRef, updatedData);
      });
    } catch (e) {
      log('Failed to update Firestore: ${e.toString()}');
    }
  }

  Future<void> updateUnlockTime({String? chatId}) async {
    if (chatId == null) return;

    await _chats.doc(chatId).set(
      {
        'is_unlocked': true,
        'unlock_time': FieldValue.serverTimestamp(),
        'expiration_time': Timestamp.fromDate(
          DateTime.now().add(
            const Duration(days: 7),
          ),
        ),
      },
      SetOptions(merge: true),
    );
  }

  Future<String> sendMessage(
    String content, {
    required String chatId,
    List<XFile>? pictures,
    required bool isConnected,
    required CurrentChat currentChat,
  }) async
  // lb
  {
    final batch = FirebaseFirestore.instance.batch();

    final message = Message(
      message: content.isEmpty ? null : content,
      localPhoto:
          (pictures != null && pictures.isNotEmpty) ? pictures[0].path : null,
      status: isConnected ? MessageStatus.sent : MessageStatus.undelivered,
    );

    batch.set(
      _msgFirestore(chatId).doc(message.id),
      {
        ...message.toJson(),
        "timestamp": FieldValue.serverTimestamp(),
      },
    );

    final updatedMessage = message.copyWith(
      message: getMessageContent(content, pictures),
    );

    updateChatData(
      message: updatedMessage,
      chatId: chatId,
      batch: batch,
      isConnected: isConnected,
      currentChat: currentChat,
    );

    await batch.commit();

    return message.id;
  }

  Future<void> updateMessageStatus({
    required Message message,
    required String? chatId,
    required String? lastMessageId,
  }) async {
    if (chatId == null) return;

    try {
      // Update the message status
      await _chats
          .doc(chatId)
          .collection('messages')
          .doc(message.id)
          .update({'status': MessageStatus.seen.value});

      if (message.id == lastMessageId) {
        await _chats.doc(chatId).update({'status': MessageStatus.seen.value});
      }
    } catch (e) {
      log('Error updating message status: $e');
    }
  }

  Stream<SubChat?> getChatDataStream(String? chatId) {
    return _chats.doc(chatId).snapshots().map(
          (doc) => doc.exists
              ? SubChat.fromJson(
                  {...doc.data()!, 'id': doc.id},
                )
              : null,
        );
  }

  Stream<List<ChatWithUser>> getChatsStream() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return _chats
        .where('participants', arrayContains: uid)
        .orderBy('last_message_timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final chats = snapshot.docs
          .map((doc) => Chat.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Collect unique user IDs from participants (excluding current user)
      final userIds = chats
          .expand((chat) => chat.participants)
          .where((id) => id != uid)
          .toSet()
          .toList();

      // If userIds is empty, return an empty list
      if (userIds.isEmpty) {
        return <ChatWithUser>[];
      }

      // Fetch user profiles for the participants
      final userProfiles = await _fetchUserProfiles(userIds);

      // Enrich chats with user profiles and return as ChatWithUser list
      return chats.map((chat) {
        final oppId = chat.participants.firstWhere((id) => id != uid);
        final userProfile = userProfiles[oppId];
        return ChatWithUser(chat: chat, userProfile: userProfile);
      }).toList();
    });
  }

  Future<Map<String, UserProfile>> _fetchUserProfiles(
    List<String> userIds,
  ) async {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();

    return {
      for (var doc in usersSnapshot.docs)
        doc.id: UserProfile.fromJson(doc.data()),
    };
  }

  Stream<List<Message>> getChatMessagesStream({
    required int limit,
    required String chatId,
  }) {
    return _msgFirestore(chatId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList(),
        );
  }
}
