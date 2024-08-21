import 'package:flutter/material.dart';

import '../../../preferences/model/core_preferences.dart';
import '../../../preferences/model/generic_enum.dart';
import '../../model/core_profile.dart';

class EditProfileNotifier extends ChangeNotifier {
  final _coreProfile = CoreProfile();
  final _selectedItems = CorePreferences();

  CoreProfile get coreProfile => _coreProfile;
  CorePreferences get selectedItems => _selectedItems;

  dynamic getCoreValue(String key) => _coreProfile.getValue(key) ?? 'Choose';

  void setValue(GenericEnum value) {
    _selectedItems.setValue(value);

    notifyListeners();
  }

  String getValue(Type type) {
    return _selectedItems.getValue(type)?.name ?? 'Choose';
  }

  GenericEnum? getSelected(Type _) => _selectedItems.getValue(_);

  void updateProfile({
    String? bio,
    List<String>? interests,
  }) {
    _coreProfile.update(
      bio: bio,
      interests: interests,
    );
    notifyListeners();
  }
}
