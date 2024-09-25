import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/chat.dart';

class ChatRepository {
  final _chatFirestore = FirebaseFirestore.instance.collection('userchats');

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
