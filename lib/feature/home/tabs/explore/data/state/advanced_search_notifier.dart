import 'package:flutter/cupertino.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../preferences/model/core_preferences.dart';
import '../../../../preferences/model/generic_enum.dart';
import '../../../../preferences/model/other_preferences.dart';

class AdvancedSearchNotifier extends ChangeNotifier
    implements SearchPreferencesNotifier {
  // Placeholder dynamic preferences for AdvancedSearch
  CorePreferences? _dynCorePrefs;
  OtherPreferences? _dynOtherPrefs;

  CorePreferences? _statCorePrefs;
  OtherPreferences? _statOtherPrefs;

  @override
  CorePreferences? get selectedItems => _dynCorePrefs;

  @override
  OtherPreferences? get otherPreferences => _dynOtherPrefs;

  @override
  bool get hasChanges {
    if (_dynCorePrefs == null ||
        _statCorePrefs == null ||
        _dynOtherPrefs == null ||
        _statOtherPrefs == null) {
      return false;
    }
    bool corePrefs = _dynCorePrefs != _statCorePrefs;
    bool otherPrefs = _dynOtherPrefs != _statOtherPrefs;

    return corePrefs || otherPrefs;
  }

  @override
  void setValue(GenericEnum value) {
    _dynCorePrefs?.setValue(value);
    notifyListeners();
  }

  @override
  String getValue(Type type) => _dynCorePrefs?.getValue(type)?.name ?? 'Choose';

  @override
  GenericEnum? getSelected(Type type) => _dynCorePrefs?.getValue(type);

  @override
  Future<void> getFilters({
    required void Function(String) showSnackbar,
  }) async {
    // Simulate a delay of 3 seconds
    await Future.delayed(const Duration(seconds: 3));

    // Placeholder logic, simulate fetchFilters functionality for now
    _dynCorePrefs = CorePreferences(); // Use default or mock data for now
    _dynOtherPrefs = OtherPreferences(); // Use default or mock data for now

    notifyListeners();
  }

  void clear() {
    _dynCorePrefs = null;
    _dynOtherPrefs = null;
  }

  @override
  Future<void> saveFilters({
    required void Function(String) showSnackbar,
  }) async {
    // Placeholder logic, simulate saveFilters functionality for now
    // Add actual logic for saving filters later
    notifyListeners();
  }

  @override
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
    _dynOtherPrefs?.update(
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

// Optionally add more functions that are relevant to AdvancedSearchNotifier
}
