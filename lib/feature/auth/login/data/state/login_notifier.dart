import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/feature/auth/login/data/repository/authentication_repository.dart';

import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../../sign_up/data/repository/user_repository.dart';

class LoginNotifier extends ChangeNotifier {
  final _userRepository = UserRepository();
  final _authRepository = AuthenticationRepository();
  UserCredential? userCredential;

  bool _createSpinner = false;

  bool get spinnerState => _createSpinner;

  set spinnerState(bool value) {
    _createSpinner = value;
    notifyListeners();
  }

  Future<void> accountCheck({
    User? user,
    bool showIfNull = false,
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
    required VoidCallback toCreateAccount,
    required VoidCallback toOnboarding,
    required void Function(UserCredential) showEmailSnackbar,
  }) async {
    if (user == null) {
      if (showIfNull) showSnackbar(AppStrings.errorUnknown);

      return;
    }

    if (user.emailVerified) {
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
    } else {
      // Email is not verified, show the Snackbar
      showEmailSnackbar(userCredential!);
    }
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

      userCredential = await _authRepository.handleEmailLogin(email, password);

      await accountCheck(
        showIfNull: true,
        user: userCredential?.user,
        showSnackbar: showSnackbar,
        onAuthenticate: onAuthenticate,
        toCreateAccount: toCreateAccount,
        toOnboarding: toOnboarding,
        showEmailSnackbar: showEmailSnackbar,
      );
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e, showSnackbar);
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
    } finally {
      spinnerState = false;
    }
  }

  Future<void> loginWithGoogle({
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
    required VoidCallback toCreateAccount,
    required VoidCallback toOnboarding,
    required void Function(UserCredential) showEmailSnackbar,
  }) async {
    try {
      userCredential = await _authRepository.handleGoogleLogin();

      await accountCheck(
        user: userCredential?.user,
        showSnackbar: showSnackbar,
        onAuthenticate: onAuthenticate,
        toCreateAccount: toCreateAccount,
        toOnboarding: toOnboarding,
        showEmailSnackbar: showEmailSnackbar,
      );
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e, showSnackbar);
    } on UnregisteredEmailException catch (e) {
      showSnackbar(e.message);
    } catch (e) {
      log('Attempting to sign in from google. Error $e');
      showSnackbar(AppStrings.accUnselected);
    } finally {}
  }

  Future<void> loginWithFacebook({
    required void Function(String) showSnackbar,
  }) async {
    try {
      await _authRepository.handleFacebookLogin();
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthError(e, showSnackbar);
    } on UnregisteredEmailException catch (e) {
      showSnackbar(e.message);
    } catch (e) {
      showSnackbar(AppStrings.accUnselected);
    } finally {}
  }

  Future<void> sendPasswordResetEmail({
    required String email,
    required void Function(String) showSnackbar,
    required void Function(String) onAuthenticate,
  }) async {
    try {
      spinnerState = true;

      final response = await _authRepository.resetPassword(email);

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
