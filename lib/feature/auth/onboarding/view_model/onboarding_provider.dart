import 'dart:io';

import 'package:flutter/material.dart';

import '../model/user_profile.dart';

class OnboardingProvider extends ChangeNotifier {
  // Selected items set
  final Set<String> _selectedItems = {};

  // Getter to access selected items
  Set<String> get selectedItems => _selectedItems;

  // Getter to access the count of selected items
  int get selectedCount => _selectedItems.length;

  // Method to check if an item is selected
  bool isSelectedTile(String item) => _selectedItems.contains(item);

  // Method to toggle the selection of an item
  void toggleSelection(String item) {
    if (_selectedItems.contains(item)) {
      _selectedItems.remove(item);
    } else {
      _selectedItems.add(item);
    }
    notifyListeners();
  }

  // Page selections map
  final Map<int, bool> _selections = {};

  // Method to check if a page is selected
  bool isSelected(int pageIndex) {
    // Special condition for page index 4
    if (pageIndex == 4 && selectedItems.length > 4) {
      return true;
    }
    return _selections[pageIndex] ?? false;
  }

  // Method to mark a page as selected
  void select(int pageIndex, {bool value = true}) {
    _selections[pageIndex] = value;
    notifyListeners();
  }

  // User profile data
  final UserProfile _userProfile = UserProfile();

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
    if (relationshipPref != null) {
      _userProfile.relationshipPref = relationshipPref;
    }
    if (meet != null) _userProfile.meet = meet;
    if (dateOfBirth != null) _userProfile.dateOfBirth = dateOfBirth;
    if (search != null) _userProfile.search = search;
    if (ticks != null) _userProfile.ticks = ticks;
    if (education != null) _userProfile.education = education;
    if (drink != null) _userProfile.drink = drink;
    if (smoker != null) _userProfile.smoker = smoker;
    if (pets != null) _userProfile.pets = pets;
    if (workOut != null) _userProfile.workOut = workOut;
    if (bio != null) _userProfile.bio = bio;
    if (profilePics != null) _userProfile.profilePics = profilePics;

    notifyListeners();
  }
}
