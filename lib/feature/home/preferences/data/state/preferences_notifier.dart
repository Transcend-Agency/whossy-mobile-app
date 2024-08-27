import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/index.dart';
import '../../model/core_preferences.dart';
import '../../model/generic_enum.dart';
import '../../model/other_preferences.dart';
import '../repository/preferences_repository.dart';

class PreferencesNotifier extends ChangeNotifier {
  CorePreferences? _selectedItems;
  final _otherPreferences = OtherPreferences();
  final _preferencesRepository = PreferencesRepository();

  bool _isLoading = false;

  bool get loadingState => _isLoading;

  set loadingState(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  CorePreferences? get selectedItems => _selectedItems;
  OtherPreferences get otherPreferences => _otherPreferences;

  void setValue(GenericEnum value) {
    _selectedItems?.setValue(value);

    notifyListeners();
  }

  String getValue(Type _) => _selectedItems?.getValue(_)?.name ?? 'Choose';

  GenericEnum? getSelected(Type _) => _selectedItems?.getValue(_);

  Future<void> getFilters({
    required void Function(String) showSnackbar,
  }) async {
    try {
      _selectedItems =
          await _preferencesRepository.fetchFilters() ?? CorePreferences();
    } on FirebaseException catch (e) {
      handleFirebaseError(e, showSnackbar);
    } catch (e) {
      showSnackbar(AppStrings.errorUnknown);
      log(e.toString());
    } finally {}

    notifyListeners();
  }

  void updatePreferences({
    int? meet,
    bool? similarInterest,
    bool? hasBio,
    int? minAge,
    int? maxAge,
    double? distance,
    bool? outreach,
    List<String>? interests,
    String? country,
    String? city,
    int? minHeight,
    int? maxHeight,
    int? minWeight,
    int? maxWeight,
  }) {
    _otherPreferences.update(
      meet: meet,
      similarInterest: similarInterest,
      hasBio: hasBio,
      minAge: minAge,
      maxAge: maxAge,
      distance: distance,
      outreach: outreach,
      interests: interests,
      country: country,
      city: city,
      minHeight: minHeight,
      maxHeight: maxHeight,
      minWeight: minWeight,
      maxWeight: maxWeight,
    );

    notifyListeners();
  }
}
