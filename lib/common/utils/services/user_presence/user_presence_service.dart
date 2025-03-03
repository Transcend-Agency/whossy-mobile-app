import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserPresenceService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  late DatabaseReference connectedRef;

  UserPresenceService() {
    // Initialize connectedRef in the constructor
    connectedRef = _database.ref('.info/connected');
  }

  DatabaseReference _userRef(String uid) =>
      _database.ref('users/$uid/presence');

  /// Initializes user presence tracking
  Future<void> trackUserPresence() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    connectedRef.onValue.listen((event) {
      final isConnected = event.snapshot.value as bool? ?? false;

      if (isConnected) {
        _userRef(user.uid).update({
          'online': true,
          'lastSeen': ServerValue.timestamp,
        });

        // Set the user offline when they disconnect
        _userRef(user.uid).onDisconnect().update({
          'online': false,
          'lastSeen': ServerValue.timestamp,
        });
      }
    });
  }

  Future<void> updateUserStatus(bool online) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    try {
      await _userRef(user.uid).update(
        {
          'online': online,
          'lastSeen': ServerValue.timestamp,
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return;
        },
      );
    } catch (e) {
      log('Online state update failed for user: ${user.uid}. Error: $e');
    }
  }
}
