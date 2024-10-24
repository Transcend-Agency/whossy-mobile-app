import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whossy_app/common/utils/enum/enums.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/source/extensions.dart';

import '../../model/chat.dart';
import '../../model/current_chat.dart';
import '../../model/message.dart';

class ChatRepository {
  final _chatFirestore = FirebaseFirestore.instance.collection('chats');

  static DatabaseReference statusRef(String id) =>
      FirebaseDatabase.instance.ref().child('users/$id/presence');

  CollectionReference<Map<String, dynamic>> _msgFirestore(String id) =>
      _chatFirestore.doc(id).collection('messages');

  Future<bool> doesChatExist(String chatId) =>
      _chatFirestore.doc(chatId).get().then((data) => data.exists);

  void updateChatData(
      Message message, String chatId, WriteBatch batch, bool isConnected) {
    batch.update(
        _chatFirestore.doc(chatId), Chat.updateChatData(message, isConnected));
  }

  Future<void> updatePhotosData({
    required String chatId,
    required String docId,
    required Map<String, String> uploadResults,
  }) async
  // lb
  {
    log('Upload Results: $uploadResults'); // Log the upload results

    try {
      final msgRef = _msgFirestore(chatId).doc(docId);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(msgRef);
        if (!snapshot.exists) return;

        // Use your `Message.fromJson` method to deserialize the snapshot data
        final message =
            Message.fromJson(snapshot.data() as Map<String, dynamic>);

        log('Original Message Data: ${message.toString()}'); // Log the original message data

        final localPhotos = List<String>.from(message.localPhotos ?? []);
        final photos = List<String>.from(message.photos ?? []);

        // For each uploaded file, remove local path and add download URL
        uploadResults.forEach((localPath, downloadUrl) {
          localPhotos.remove(localPath);

          // Only add the downloadUrl if it doesn't already exist
          if (!photos.contains(downloadUrl)) {
            photos.add(downloadUrl);
          }
        });

        // Prepare the updated data
        final updatedData = {
          'local_photos': localPhotos,
          'photos': photos,
        };

        // Log the data you're about to write
        log('Updated Data to Write: $updatedData');

        // Update Firestore with the modified lists
        transaction.update(msgRef, updatedData);
      });
    } catch (e) {
      log('Failed to update Firestore: ${e.toString()}');
    }
  }

  Future<String> createNewChat(
    String content, {
    required CurrentChat currentChat,
    required String userName,
    required String picUrl,
    List<XFile>? pictures,
    required bool isConnected,
  }) async
  // lb
  {
    final chat = Chat(
      participants: [currentChat.uidUser1, currentChat.uidUser2],
      lastMessage: content,
      userNames: [userName, currentChat.username],
      profilePicUrls: [picUrl, currentChat.profilePicUrl],
      lastMessageId: '',
      lastMessageStatus:
          isConnected ? MessageStatus.sent : MessageStatus.undelivered,
    );

    await _chatFirestore.doc(currentChat.chatId).set(
      {
        ...chat.toJson(),
        'last_message_timestamp': FieldValue.serverTimestamp(),
      },
    );

    return await sendMessage(
      content,
      chatId: currentChat.chatId!,
      pictures: pictures,
      isConnected: isConnected,
    );
  }

  Future<String> sendMessage(
    String content, {
    required String chatId,
    List<XFile>? pictures,
    required bool isConnected,
  }) async
  // lb
  {
    final batch = FirebaseFirestore.instance.batch();

    final message = Message(
      message: content,
      localPhotos: pictures?.paths,
      status: isConnected ? MessageStatus.sent : MessageStatus.undelivered,
    );

    batch.set(
      _msgFirestore(chatId).doc(message.id),
      {
        ...message.toJson(),
        "timestamp": FieldValue.serverTimestamp(),
      },
    );

    updateChatData(message, chatId, batch, isConnected);

    await batch.commit();

    return message.id;
  }

  Stream<List<Chat>> getChatsStream() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return _chatFirestore
        .where('participants', arrayContains: userId)
        .orderBy('last_message_timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            // .where((chat) => filterDeleted(chat.data(), userId))
            // .where((chat) => filterBlocked(chat.data(), userId))
            // .where((chat) => filterChatSearchQuery(chat.data(), userId))
            .map((doc) => Chat.fromJson({...doc.data(), 'id': doc.id}))
            .toList());
  }

  Stream<List<Message>> getChatMessagesStream({
    required int limit,
    required String chatId,
  })
  // lb
  {
    // Use the limit method to fetch a specific number of messages
    final query = _msgFirestore(chatId)
        .orderBy('timestamp', descending: true)
        .limit(limit);

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }
}

/*
 bool filterDeleted(Map<String, dynamic> chatData, String uid) {
    final participants = chatData['participants'] as List<dynamic>?;

    final deletedAccount = chatData['deletedAccount'] as List<dynamic>?;

    if (participants == null || deletedAccount == null) {
      return true; // Handle missing data gracefully
    }

    int currentUserIndex = participants.indexOf(uid);
    final data = deletedAccount[currentUserIndex] as bool?;

    return data != null ? !data : false;
  }

  bool filterBlocked(
    Map<String, dynamic> chatData,
    String uid, {
    bool onlyBlocked = false,
  }) {
    log('Chat data $chatData');
    final participants = chatData['participants'] as List<dynamic>;
    final currentUserPosition = participants.indexOf(uid);

    if (currentUserPosition != -1) {
      final oppositePosition = (currentUserPosition + 1) % 2;
      final oppUserBlocked = chatData['user_blocked'][oppositePosition] as bool;

      if (onlyBlocked) {
        return oppUserBlocked;
      } else {
        return !oppUserBlocked;
      }
    }

    return false;
  }
 */
