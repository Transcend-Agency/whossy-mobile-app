import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<bool> isFirstTimeOpened(String pageKey, String? uid) async {
    final asyncPrefs = SharedPreferencesAsync();

    final key = '$uid - $pageKey';

    final bool? isFirstTime = await asyncPrefs.getBool(key);

    if (isFirstTime == null) {
      await asyncPrefs.setBool(key, false);
      return true;
    }

    return false;
  }
}
