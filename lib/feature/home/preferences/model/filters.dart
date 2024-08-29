import 'core_preferences.dart';
import 'other_preferences.dart';

class Filters {
  final Map<String, dynamic> data;

  Filters({required CorePreferences core, required OtherPreferences other})
      : data = {
          'core': core,
          'other': other,
        };

  CorePreferences get corePreferences => data['core'] as CorePreferences;
  OtherPreferences get otherPreferences => data['other'] as OtherPreferences;
}
