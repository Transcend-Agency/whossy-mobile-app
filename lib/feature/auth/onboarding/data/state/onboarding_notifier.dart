import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whossy_app/common/utils/exceptions/failed_upload.dart';
import 'package:whossy_app/feature/auth/onboarding/data/repository/preference_repository.dart';

import '../../../../../constants/index.dart';
import '../../../sign_up/data/repository/user_repository.dart';
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
      final urls = await _userRepository
          .uploadProfilePictures(_userPreferences.picFiles ?? []);
      updateUserProfile(profilePics: urls);

      // Upload preferences and complete onboarding
      await _prefRepository.uploadPreferences(data: _userPreferences.toJson());
      await _userRepository
          .setUserData(data: {"has_completed_onboarding": true});

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
    int? pet,
    int? smoker,
    int? workOut,
    String? bio,
    List<String>? profilePics,
    List<File>? picFiles,
  }) {
    _userPreferences.update(
      relationshipPref: relationshipPref,
      meet: meet,
      dateOfBirth: dateOfBirth,
      search: search,
      ticks: ticks,
      drink: drink,
      smoker: smoker,
      petOwner: pet,
      workOut: workOut,
      bio: bio,
      profilePics: profilePics,
      picFiles: picFiles,
    );

    notifyListeners();
  }
}
