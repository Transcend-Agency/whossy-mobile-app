import '../../model/core_preferences.dart';
import '../../model/generic_enum.dart';
import '../../model/other_preferences.dart';

abstract class SearchPreferencesNotifier {
  // Abstract getter for OtherPreferences
  OtherPreferences? get otherPreferences;

  // Abstract getter for CorePreferences
  CorePreferences? get selectedItems;

  // Abstract method to update preferences
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
  });

  // Abstract method to set a value
  void setValue(GenericEnum value);

  // Abstract method to get a value
  String getValue(Type type);

  // Abstract method to get the selected value
  GenericEnum? getSelected(Type type);

  // Abstract property to check if there are changes
  bool get hasChanges;

  // Abstract method to fetch filters
  Future<void> getFilters({required void Function(String) showSnackbar});

  // Abstract method to save filters
  Future<void> saveFilters({required void Function(String) showSnackbar});
}
