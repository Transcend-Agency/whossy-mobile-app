import 'package:whossy_app/feature/auth/onboarding/model/preferences.dart';

import '../../../auth/sign_up/model/app_user.dart';

class ProfileData {
  final Map<String, dynamic> data;

  ProfileData({required AppUser? user, required Preferences? prefs})
      : data = {
          'user': user,
          'prefs': prefs,
        };

  AppUser? get user => data['user'] as AppUser?;
  Preferences? get prefs => data['prefs'] as Preferences?;
}
