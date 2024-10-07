import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  late DatabaseReference connectedRef;

  UserService() {
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

  /// Updates user online/offline status manually (when app state changes)
  Future<void> updateUserStatus(bool online) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await _userRef(user.uid).update({
      'online': online,
      'lastSeen': ServerValue.timestamp,
    });
  }
}
