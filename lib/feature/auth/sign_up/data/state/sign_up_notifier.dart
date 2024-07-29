import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../constants/index.dart';
import '../../model/app_user.dart';
import '../repository/user_repository.dart';

class SignUpNotifier extends ChangeNotifier {
  final _userRepository = UserRepository();
  AppUser _user = AppUser();
  UserCredential? userCredential;

  String tc = 'https://www.google.com/';

  Future<void> launchTC() async {
    final Uri url = Uri.parse(tc);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  bool _createSpinner = false;

  bool get spinnerState => _createSpinner;

  set spinnerState(bool value) {
    _createSpinner = value;
    notifyListeners();
  }

  Future<void> setBaseData({
    required String email,
    String provider = 'local',
  }) async {
    final uid = userCredential!.user!.uid;

    try {
      updateAppUser(uid: uid, email: email, authProvider: provider);

      await _userRepository.setUserData(_user);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeCreation({
    required String gender,
    required void Function(String) showSnackbar,
    required VoidCallback onVerifyMail,
    required VoidCallback toWelcome,
  }) async {
    try {
      spinnerState = true;

      // Update the remaining fields
      updateAppUser(gender: gender, hasCompletedAccountCreation: true);

      // Upload to Firebase
      await _userRepository.updateUserData(_user.toUpdateCreate());

      User? user = userCredential?.user;

      if (user != null) {
        // Update the display name
        await user.updateDisplayName(_user.firstName);

        if (user.emailVerified) {
          toWelcome();
          return;
        }
        // Send email verification to new user
        await user.sendEmailVerification();

        // Call the function to proceed to verify mail screen
        onVerifyMail();
      } else {
        // User is null
        showSnackbar(AppStrings.errorUnknown);
      }
    } on FirebaseException catch (e) {
      handleFirebaseAuthError(e, showSnackbar);
    } catch (e) {
      log('Unexpected error: $e');
      showSnackbar(AppStrings.errorUnknown);
    } finally {
      spinnerState = false;
    }
  }

  Future<void> createAccount({
    required String email,
    required String password,
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
  }) async {
    try {
      spinnerState = true;

      userCredential = await _userRepository.createUser(email, password);

      // Update data in firebase
      setBaseData(email: email);

      // Account creation successful, handle accordingly
      onAuthenticate();
    } on FirebaseException catch (e) {
      // Respond accordingly
      handleFirebaseAuthError(e, showSnackbar);
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
    } finally {
      spinnerState = false;
    }
  }

  Future<Map<String, dynamic>> isPhoneUnique(String phone) async {
    try {
      bool isEmpty = await _userRepository.isPhoneUnique(phone);

      return {
        'isEmpty': isEmpty,
      };
    } on FirebaseException catch (e) {
      const message = 'Unable to check, device offline';

      log('Error checking if phone number is unique, '
          'A Firebase Exception occurred ${e.toString()}');

      return {
        'message': message,
      };
    } catch (e) {
      log('Error checking for unique phone number ${e.toString()}');
    }
    return {
      'message': 'Oops, an unknown error occurred',
    };
  }

  void updateAppUser({
    String? uid,
    String? email,
    String? firstName,
    String? lastName,
    String? gender,
    String? phoneNumber,
    String? countryOfOrigin,
    String? authProvider,
    bool? hasCompletedAccountCreation,
    bool? hasCompletedAccountOnboarding,
  }) {
    // Create a new AppUser instance with updated values
    _user = AppUser(
      uid: uid ?? _user.uid,
      email: email ?? _user.email,
      firstName: firstName ?? _user.firstName,
      lastName: lastName ?? _user.lastName,
      gender: gender ?? _user.gender,
      phoneNumber: phoneNumber ?? _user.phoneNumber,
      countryOfOrigin: countryOfOrigin ?? _user.countryOfOrigin,
      authProvider: authProvider ?? _user.authProvider,
      hasCompletedAccountCreation:
          hasCompletedAccountCreation ?? _user.hasCompletedAccountCreation,
      hasCompletedAccountOnboarding:
          hasCompletedAccountOnboarding ?? _user.hasCompletedAccountOnboarding,
    );

    // Notify listeners about the change
    notifyListeners();
  }
}
