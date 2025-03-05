import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/common/utils/exceptions/failed_upload.dart';
import 'package:whossy_app/feature/auth/onboarding/data/repository/preference_repository.dart';

import '../../../../../constants/index.dart';
import '../../../sign_up/data/repository/user_repository.dart';
import '../../model/face_verification.dart';
import '../../model/preferences.dart';

class OnboardingNotifier extends ChangeNotifier {
  final _prefRepository = PreferenceRepository();
  final _userRepository = UserRepository();

  int ticks = 0;

  // Page selections map
  final Map<int, bool> _selections = {};

  // User profile data
  Preferences _userPreferences = Preferences();

  // Method to check if a page is selected
  bool isSelected(int pageIndex) {
    // Special condition for page index 4
    if (pageIndex == 4 && ticks > 4) {
      return true;
    }
    return _selections[pageIndex] ?? false;
  }

  // Method to mark a page as selected
  void select(int pageIndex, {bool value = true}) {
    _selections[pageIndex] = value;
    notifyListeners();
  }

  bool _createSpinner = false;

  bool get spinnerState => _createSpinner;

  set spinnerState(bool value) {
    _createSpinner = value;
    notifyListeners();
  }

  Future<void> uploadPreferences({
    required void Function(String) showSnackbar,
    required VoidCallback onAuthenticate,
  }) async {
    try {
      spinnerState = true;

      // Upload profile pictures and update user profile
      final urls = await _userRepository.uploadPictures(
        files: _userPreferences.picFiles ?? [],
        pathGenerator: AppStrings.profilePicsPath,
      );

      final photoVerificationUrl = await _userRepository.uploadPictures(
        files: _userPreferences.verPicFile != null
            ? [_userPreferences.verPicFile!]
            : [],
        pathGenerator: AppStrings.faceVerPicPath,
      );

      updateUserProfile(profilePics: urls);

      // Create FaceVerification instance only if there is a verification photo
      FaceVerification? faceVerification;
      if (photoVerificationUrl.isNotEmpty) {
        faceVerification = FaceVerification(
          photo: photoVerificationUrl.first,
        );
      }

      // Construct user data map dynamically
      final Map<String, dynamic> userData = {
        "has_completed_onboarding": true,
        ..._userPreferences.toJson(),
        if (faceVerification != null)
          "face_verification": faceVerification.toJson()
            ..['updated_at'] = FieldValue.serverTimestamp(),
      };

      // Upload preferences and complete onboarding
      await _prefRepository.uploadFilters(data: _userPreferences.toJson());
      await _userRepository.setUserData(data: userData);

      await _userRepository.addUserToken();

      onAuthenticate();
    } on FailedUploadException catch (e) {
      showSnackbar(e.message);
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
    } finally {
      spinnerState = false;
    }
  }

  // Reset function to clear user preferences and selections
  void reset() {
    ticks = 0;
    _selections.clear();
    _userPreferences = Preferences();
    _createSpinner = false;
    notifyListeners();
  }

  // Update user profile fields and notify listeners
  void updateUserProfile({
    int? relationshipPref,
    int? meet,
    DateTime? dateOfBirth,
    int? search,
    List<String>? ticks,
    int? drink,
    int? pets,
    int? smoker,
    int? workOut,
    String? bio,
    List<String>? profilePics,
    List<File>? picFiles,
    File? verPicFile,
  }) {
    _userPreferences.update(
      relationshipPref: relationshipPref,
      meet: meet,
      dateOfBirth: dateOfBirth,
      search: search,
      ticks: ticks,
      drink: drink,
      smoker: smoker,
      petOwner: pets,
      workOut: workOut,
      bio: bio,
      profilePics: profilePics,
      picFiles: picFiles,
      verPicFile: verPicFile,
    );

    // log(_userPreferences.toJson().toString());

    notifyListeners();
  }
}
