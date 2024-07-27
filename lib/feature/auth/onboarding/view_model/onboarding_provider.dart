import 'dart:io';

import 'package:flutter/material.dart';

import '../model/preferences.dart';

class OnboardingProvider extends ChangeNotifier {
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

  // Update user profile fields and notify listeners
  void updateUserProfile({
    String? relationshipPref,
    String? meet,
    DateTime? dateOfBirth,
    int? search,
    List<String>? ticks,
    String? education,
    String? drink,
    String? smoker,
    List<String>? pets,
    String? workOut,
    String? bio,
    List<File>? profilePics,
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
