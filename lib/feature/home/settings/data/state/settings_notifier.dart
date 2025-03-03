import 'package:flutter/material.dart';
import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';

import '../../../../../common/utils/services/services.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../tabs/matching/model/user_profile.dart';
import '../../model/user_settings.dart';

class SettingsNotifier extends ChangeNotifier {
  final _settings = UserSettings();
  final _userService = UserPresenceService();
  final _userRepository = UserRepository();

  UserSettings get settings => _settings;

  bool getValue(CoreSettings setting) {
    return _settings.getValue(setting) ?? false;
  }

  Future<List<UserProfile>> getBlockedUsers(List<String> userIds) {
    return _userRepository.getUserProfilesInBatches(
      userIds: userIds,
      blockedIds: [],
      settings: const ExcludeSettings(
        excludeIncompleteOnboarding: true,
        excludeBannedUsers: true,
        excludeUnapprovedUsers: false,
        excludeBlockedAndSelf: false,
      ),
    );
  }

  void updateSwitch(CoreSettings setting, bool newValue) {
    _settings.updateSwitch(setting, newValue);

    notifyListeners();
  }

  Future<void> signOut(void Function(String) showSnackbar) async {
    try {
      await _userService.updateUserStatus(false);

      await _userRepository.signOut();
    } catch (e) {
      showSnackbar(AppStrings.signOutFailure);
    }

    notifyListeners();
  }
}
