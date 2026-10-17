import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserPresenceService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  late DatabaseReference connectedRef;

  // Refreshes lastSeen while connected, so "online" reflects genuine recent
  // activity rather than only the last connect/reconnect event (pre-launch
  // plan C1) — onDisconnect can lag or never fire on a force-quit.
  static const _heartbeatInterval = Duration(seconds: 90);
  Timer? _heartbeatTimer;

  UserPresenceService() {
    // Initialize connectedRef in the constructor
    connectedRef = _database.ref('.info/connected');
  }

  DatabaseReference _userRef(String uid) =>
      _database.ref('users/$uid/presence');

  bool _connected = false;

  /// Starts presence tracking for whoever is signed in, following sign-in
  /// and sign-out. The uid is read on every write: a uid captured once would
  /// keep being written after another account signs in, which the database
  /// rules refuse.
  void trackUserPresence() {
    connectedRef.onValue.listen((event) {
      _connected = event.snapshot.value as bool? ?? false;
      _refreshPresence();
    });

    FirebaseAuth.instance.authStateChanges().listen((_) => _refreshPresence());
  }

  void _refreshPresence() {
    _heartbeatTimer?.cancel();

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (!_connected || uid == null) return;

    final ref = _userRef(uid);
    final online = {'online': true, 'lastSeen': ServerValue.timestamp};

    _logFailure(ref.update(online));
    _logFailure(ref.onDisconnect().update({
      'online': false,
      'lastSeen': ServerValue.timestamp,
    }));

    _heartbeatTimer = Timer.periodic(_heartbeatInterval, (_) {
      if (FirebaseAuth.instance.currentUser?.uid != uid) return;
      _logFailure(ref.update(online));
    });
  }

  void _logFailure(Future<void> write) {
    write.catchError((Object e) => log('Presence update failed: $e'));
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
        const Duration(seconds: 3),
        onTimeout: () {
          return;
        },
      );
    } catch (e) {
      log('Online state update failed for user: ${user.uid}. Error: $e');
    }
  }
}
