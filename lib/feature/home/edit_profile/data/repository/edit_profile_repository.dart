import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';

import '../../../../auth/onboarding/data/repository/preference_repository.dart';
import '../../../../auth/onboarding/model/preferences.dart';
import '../../../../auth/sign_up/model/app_user.dart';
import '../../model/get_profile_data.dart';

class EditProfileRepository {
  final _userRepository = UserRepository();
  final _prefRepository = PreferenceRepository();

  Future<ProfileData?> fetchProfileData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final results = await Future.wait([
      _userRepository.getUserData(uid),
      _prefRepository.getPreferences(uid)
    ]);

    final userData = results[0] as AppUser?;
    final prefs = results[1] as Preferences?;

    // log("The prefs is ${prefs.toString()}");

    if (userData == null && prefs == null) return null;

    return ProfileData(user: userData, prefs: prefs);
  }

  Future<void> updateProfileData({
    required Map<String, dynamic> coreProfileData,
    required Map<String, dynamic> corePrefData,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (coreProfileData.isNotEmpty) {
      await _userRepository.setUserData(id: uid, data: coreProfileData);
    }

    if (corePrefData.isNotEmpty) {
      await _prefRepository.uploadPreferences(uid: uid, data: corePrefData);
    }
  }
}
