import 'package:flutter/material.dart';
import 'package:whossy_app/feature/auth/sign_up/data/repository/user_repository.dart';

import '../../../../../common/utils/enum/enums.dart';
import '../../../../../common/utils/services/services.dart';
import '../../../../../constants/index.dart';
import '../../../tabs/matching/model/user_profile.dart';
import '../../model/settings_model.dart';

class SettingsNotifier extends ChangeNotifier {
  final _settings = SettingsModel();
  final _authService = AuthenticationService();
  final _userService = UserService();
  final _userRepository = UserRepository();

  SettingsModel get settings => _settings;

  bool getValue(CoreSettings setting) {
    return _settings.getValue(setting) ?? false;
  }

  Future<List<UserProfile>> getBlockedUsers(List<String> userIds) {
    return _userRepository.getUserProfilesInBatches(userIds);
  }

  void updateSwitch(CoreSettings setting, bool newValue) {
    _settings.updateSwitch(setting, newValue);

    notifyListeners();
  }

  void updateSettings({List<String>? blocked}) {
    _settings.update(blocked: blocked);

    notifyListeners();
  }

  Future<void> signOut(void Function(String) showSnackbar) async {
    try {
      await _userService.updateUserStatus(false);

      await _authService.signOut();
    } catch (e) {
      showSnackbar(AppStrings.signOutFailure);
    }

    notifyListeners();
  }
}
