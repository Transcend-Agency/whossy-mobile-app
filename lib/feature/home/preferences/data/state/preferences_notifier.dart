import 'package:flutter/material.dart';

import '../../model/core_preferences.dart';
import '../../model/generic_enum.dart';
import '../../model/other_preferences.dart';

class PreferencesNotifier extends ChangeNotifier {
  final _selectedItems = CorePreferences();
  final _otherPreferences = OtherPreferences();

  CorePreferences get selectedItems => _selectedItems;
  OtherPreferences get otherPreferences => _otherPreferences;

  void setValue(GenericEnum value) {
    _selectedItems.setValue(value);

    notifyListeners();
  }

  String getValue(Type type) {
    return _selectedItems.getValue(type)?.name ?? 'Choose';
  }

  GenericEnum? getSelected(Type _) => _selectedItems.getValue(_);

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
