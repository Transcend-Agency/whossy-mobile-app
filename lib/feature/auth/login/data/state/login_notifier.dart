import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../../sign_up/data/repository/user_repository.dart';
import '../../model/auth_params.dart';
import '../repository/authentication_repository.dart';

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
    bool disableEmailCheck = false,
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
    required VoidCallback toCreateAccount,
    required VoidCallback toOnboarding,
    void Function(UserCredential)? showEmailSnackbar,
  }) async {
    if (user == null) {
      if (showIfNull) showSnackbar(AppStrings.errorUnknown);

      return;
    }

    if (user.emailVerified || disableEmailCheck) {
      final appUser = await _userRepository.getUserData();

      if (appUser != null) {
        if (!appUser.hasCompletedAccountCreation) {
          toCreateAccount();
          return;
        }

        if (!appUser.hasCompletedOnboarding) {
          toOnboarding();
          return;
        }
      }

      onAuthenticate();
    } else {
      // Email is not verified, show the Snackbar
      showEmailSnackbar!(userCredential!);
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
      userCredential = await _authRepository.handleGoogleAuthentication();

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
    } on PlatformException catch (e) {
      if (e.code == 'network_error') {
        showSnackbar(AppStrings.deviceOffline);
      } else {
        log('Google sign-in failed. Error: ${e.message}');
        showSnackbar(AppStrings.errorUnknown);
      }
    } catch (e) {
      log('Attempting to sign in from google. Error $e');
      showSnackbar(AppStrings.errorUnknown);
    }
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

  Future<void> loginWithPhoneNumber({
    required String id,
    required String code,
    required void Function(String) showSnackbar,
    required VoidCallback toCreateAccount,
    required VoidCallback toOnboarding,
    required VoidCallback onAuthenticate,
  }) async {
    try {
      spinnerState = true;

      final cred = AuthParams.withIdAndCode(id, code);

      userCredential = await _authRepository.handlePhoneAuthentication(cred);

      await accountCheck(
        user: userCredential?.user,
        showSnackbar: showSnackbar,
        onAuthenticate: onAuthenticate,
        toCreateAccount: toCreateAccount,
        toOnboarding: toOnboarding,
        disableEmailCheck: true,
      );
    } on FirebaseException catch (e) {
      handleFirebaseAuthError(e, showSnackbar);
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
    } finally {
      spinnerState = false;
    }
  }

  Future<void> sendPhoneNumberCode({
    required String phone,
    required void Function(String) showSnackbar,
    required void Function(String, String, int?) onSend,
    required VoidCallback toCreateAccount,
    required VoidCallback toOnboarding,
    required VoidCallback onAuthenticate,
    int? resendingToken,
  }) async {
    try {
      spinnerState = true;

      final credential = await _authRepository.sendOTPCode(
        phone,
        onSend,
        showSnackbar,
        resendingToken,
      );

      if (credential != null) {
        final cred = AuthParams.withCredential(credential);

        userCredential = await _authRepository.handlePhoneAuthentication(cred);

        await accountCheck(
          user: userCredential?.user,
          showSnackbar: showSnackbar,
          onAuthenticate: onAuthenticate,
          toCreateAccount: toCreateAccount,
          toOnboarding: toOnboarding,
          disableEmailCheck: true,
        );
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
