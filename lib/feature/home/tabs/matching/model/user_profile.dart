import '../../../../auth/onboarding/model/preferences.dart';
import '../../../../auth/sign_up/model/app_user.dart';

class UserProfile {
  final AppUser user;
  final Preferences preferences;

  UserProfile({required this.user, required this.preferences});

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final user = AppUser.fromJson(json);
    final preferences = Preferences.fromJson(json);
    return UserProfile(user: user, preferences: preferences);
  }
}
