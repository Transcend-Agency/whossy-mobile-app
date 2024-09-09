import 'package:flutter/material.dart';

import '../../../../../common/utils/enum/enums.dart';
import '../../../../../common/utils/services/services.dart';
import '../../../../../constants/index.dart';
import '../../model/settings_model.dart';

class SettingsNotifier extends ChangeNotifier {
  final _settings = SettingsModel();
  final _authService = AuthenticationService();

  SettingsModel get settings => _settings;

  bool getValue(CoreSettings setting) {
    return _settings.getValue(setting) ?? false;
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
      await _authService.signOut();
    } catch (e) {
      showSnackbar(AppStrings.signOutFailure);
    }

    notifyListeners();
  }
}
