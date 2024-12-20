import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/feature/auth/login/data/repository/authentication_repository.dart';

class AuthenticationService {
  final _auth = FirebaseAuth.instance;
  final _authRepo = AuthenticationRepository();

  Future<void> signOut() async {
    try {
      // Reset FCM token
      // Sign out from Firebase
      await _auth.signOut();
    } catch (e) {
      // Handle sign-out error
      log('Error signing out: $e');

      rethrow;
    }
  }
}
