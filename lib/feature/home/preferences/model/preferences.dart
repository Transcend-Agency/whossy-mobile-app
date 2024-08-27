import 'core_preferences.dart';
import 'other_preferences.dart';

class Preferences {
  final Map<String, dynamic> data;

  Preferences({required CorePreferences core, required OtherPreferences other})
      : data = {
          'core': core,
          'other': other,
        };

  CorePreferences get corePreferences => data['core'] as CorePreferences;
  OtherPreferences get otherPreferences => data['other'] as OtherPreferences;
}
