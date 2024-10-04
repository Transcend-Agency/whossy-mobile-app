import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/current_chat.dart';

import '../../model/chat.dart';
import '../../model/message.dart';

class ChatRepository {
  final _chatFirestore = FirebaseFirestore.instance.collection('userchats');

  CollectionReference<Map<String, dynamic>> _msgFirestore(String id) =>
      _chatFirestore.doc(id).collection('messages');

  Future<bool> doesChatExist(String chatId) =>
      _chatFirestore.doc(chatId).get().then((data) => data.exists);

  void updateChatData(Message message, String chatId, WriteBatch batch) {
    batch.update(_chatFirestore.doc(chatId), Chat.updateChatData(message));
  }

  Future<void> createNewChat(
    String content, {
    required CurrentChat currentChat,
    required String userName,
    required String picUrl,
  }) async {
    final chat = Chat(
      participants: [currentChat.uidUser1, currentChat.uidUser2],
      lastMessage: content,
      userNames: [userName, currentChat.username],
      profilePicUrls: [picUrl, currentChat.profilePicUrl],
      lastMessageId: '',
    );

    await _chatFirestore.doc(currentChat.chatId).set({
      ...chat.toJson(),
      'last_message_timestamp': FieldValue.serverTimestamp(),
    });

    await sendMessage(content, chatId: currentChat.chatId!);
  }

  Future<void> sendMessage(String content, {required String chatId}) async {
    final batch = FirebaseFirestore.instance.batch();

    final message = Message(message: content);

    batch.set(_msgFirestore(chatId).doc(message.id), {
      ...message.toJson(),
      "timestamp": FieldValue.serverTimestamp(),
    });

    updateChatData(message, chatId, batch);

    await batch.commit();
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
  }) {
    // Use the limit method to fetch a specific number of messages
    final query = _msgFirestore(chatId)
        .orderBy('timestamp', descending: true)
        .limit(limit);

    return query.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }

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
}
