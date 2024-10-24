import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';

import '../../../../auth/onboarding/data/repository/preference_repository.dart';
import '../../../../auth/onboarding/model/preferences.dart';
import '../../../../auth/sign_up/model/app_user.dart';
import '../../model/get_profile_data.dart';

class EditProfileRepository {
  final _userRepository = UserRepository();
  final _prefRepository = PreferenceRepository();

  Future<ProfileData?> fetchProfileData() async {
    final results = await Future.wait([
      _userRepository.getUserData(),
      _prefRepository.getPreferences(),
    ]);

    final userData = results[0] as AppUser?;
    final prefs = results[1] as Preferences?;

    if (userData == null && prefs == null) return null;

    return ProfileData(user: userData, prefs: prefs);
  }

  Future<void> updateProfileData({
    required Map<String, dynamic> coreProfileData,
    required Map<String, dynamic> corePrefData,
    required bool updateUserDeletePic,
  }) async {
    if (coreProfileData.isNotEmpty) {
      await _userRepository.setUserData(data: coreProfileData);
    }

    if (corePrefData.isNotEmpty) {
      await _prefRepository.uploadPreferences(data: corePrefData);
    }

    if (updateUserDeletePic) {
      await _prefRepository.addDeletePicQueue();
    }
  }
}
