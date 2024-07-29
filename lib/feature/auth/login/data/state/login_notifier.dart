import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/index.dart';
import '../../../sign_up/data/repository/user_repository.dart';

class LoginNotifier extends ChangeNotifier {
  final _userRepository = UserRepository();
  UserCredential? userCredential;

  bool _createSpinner = false;

  bool get spinnerState => _createSpinner;

  set spinnerState(bool value) {
    _createSpinner = value;
    notifyListeners();
  }

  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
    required VoidCallback toCreateAccount,
    required VoidCallback toOnboarding,
    required void Function(UserCredential) showEmailSnackbar,
  }) async {
    try {
      spinnerState = true;

      userCredential = await _userRepository.loginUser(email, password);

      User? user = userCredential?.user;

      // User is authenticated and email is verified
      if (user != null && user.emailVerified) {
        final appUser = await _userRepository.getUserData(user.uid);

        if (appUser != null) {
          if (!appUser.hasCompletedAccountCreation) {
            toCreateAccount();
            return;
          }

          if (!appUser.hasCompletedAccountOnboarding) {
            toOnboarding();
            return;
          }
        }

        onAuthenticate();
      } else if (user != null && user.emailVerified == false) {
        // Email is not verified, show the Snackbar
        showEmailSnackbar(userCredential!);
      } else {
        // User is null
        showSnackbar(AppStrings.errorUnknown);
      }
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e, showSnackbar);
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
    } finally {
      spinnerState = false;
    }
  }

  Future<void> sendPasswordResetEmail({
    required String email,
    required void Function(String) showSnackbar,
    required void Function(String) onAuthenticate,
  }) async {
    try {
      spinnerState = true;

      final response = await _userRepository.resetPassword(email);

      if (response.isSuccess) {
        onAuthenticate(email);
      } else {
        showSnackbar(response.message);
      }
    } on FirebaseException catch (e) {
      handleFirebaseAuthError(e, showSnackbar);
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
    } finally {
      spinnerState = false;
    }
  }
}
