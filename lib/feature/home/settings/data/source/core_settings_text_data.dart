import '../../../../../common/utils/index.dart';
import '../../model/core_settings_text.dart';

List<CoreSettingsText> coreSettingItems = [
  CoreSettingsText(isPremium: true, value: CoreSettings.incognito),
  CoreSettingsText(value: CoreSettings.incomingMessages),
  CoreSettingsText(value: CoreSettings.hideVerificationBadge),
  CoreSettingsText(value: CoreSettings.publicSearch),
  CoreSettingsText(isPremium: true, value: CoreSettings.onlineStatus),
];
