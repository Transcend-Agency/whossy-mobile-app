import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<bool> isFirstTimeOpened(String pageKey) async {
    final asyncPrefs = SharedPreferencesAsync();

    final bool? isFirstTime = await asyncPrefs.getBool(pageKey);

    if (isFirstTime == null) {
      await asyncPrefs.setBool(pageKey, false);
      return true;
    }

    return false;
  }
}
