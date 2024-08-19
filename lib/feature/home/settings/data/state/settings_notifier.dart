import 'package:flutter/material.dart';

import '../../model/settings_model.dart';

class SettingsNotifier extends ChangeNotifier {
  final _settings = SettingsModel();

  SettingsModel get settings => _settings;

  void updateSettings({
    bool? incognito,
    bool? incomingMessages,
    bool? hideBadge,
    bool? publicSearch,
    bool? onlineStatus,
    List<String>? blocked,
  }) {
    _settings.update(
      incognito: incognito,
      incomingMessages: incomingMessages,
      hideBadge: hideBadge,
      publicSearch: publicSearch,
      onlineStatus: onlineStatus,
      blocked: blocked,
    );

    notifyListeners();
  }
}
