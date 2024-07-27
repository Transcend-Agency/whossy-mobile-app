import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/data/repository/preference_repository.dart';

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

      // Send the preferences to Firebase
      await _prefRepository.uploadPreferences(_userPreferences);

      // the user has now completed the account onboarding
      _userRepository
          .updateUserData({"has_completed_account_onboarding": true});

      onAuthenticate();
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
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
    String? education,
    int? drink,
    int? smoker,
    List<String>? pets,
    int? workOut,
    String? bio,
    List<String>? profilePics,
  }) {
    _userPreferences.update(
      relationshipPref: relationshipPref,
      meet: meet,
      dateOfBirth: dateOfBirth,
      search: search,
      ticks: ticks,
      education: education,
      drink: drink,
      smoker: smoker,
      pets: pets,
      workOut: workOut,
      bio: bio,
      profilePics: profilePics,
    );

    notifyListeners();
  }
}
