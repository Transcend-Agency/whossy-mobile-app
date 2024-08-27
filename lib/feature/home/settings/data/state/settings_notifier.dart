import 'package:flutter/material.dart';

import '../../../../../common/utils/enum/enums.dart';
import '../../model/settings_model.dart';

class SettingsNotifier extends ChangeNotifier {
  final _settings = SettingsModel();

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
}
