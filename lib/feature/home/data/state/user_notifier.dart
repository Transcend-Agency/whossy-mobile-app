import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/feature/home/model/other_preferences.dart';

import '../../model/extras.dart';
import '../../model/selected_items.dart';

class UserNotifier extends ChangeNotifier {
  final _selectedItems = SelectedItems();
  final _otherPreferences = OtherPreferences();

  SelectedItems get selectedItems => _selectedItems;
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
    );

    notifyListeners();
  }
}
