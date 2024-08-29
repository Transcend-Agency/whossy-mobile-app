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
  final _userPreferences = Preferences();

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

      // Upload to storage and get urls
      final urls = await _userRepository
          .uploadProfilePictures(_userPreferences.picFiles ?? []);

      updateUserProfile(profilePics: urls);

      // Send the preferences to Firebase
      await _prefRepository.uploadPreferences(data: _userPreferences.toJson());

      // the user has now completed the account onboarding
      _userRepository.setUserData(data: {"has_completed_onboarding": true});

      onAuthenticate();
    } on Exception catch (e) {
      if (e is FailedUploadException) {
        showSnackbar((e as dynamic).message);
      } else {
        showSnackbar(AppStrings.errorUnknown);
        log(e.toString());
      }
    } finally {
      spinnerState = false;
    }
  }

  // Update user profile fields and notify listeners
  void updateUserProfile({
    int? relationshipPref,
    int? meet,
    DateTime? dateOfBirth,
    int? search,
    List<String>? ticks,
    int? drink,
    int? smoker,
    List<String>? pets,
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
      pets: pets,
      workOut: workOut,
      bio: bio,
      profilePics: profilePics,
      picFiles: picFiles,
    );

    notifyListeners();
  }
}
