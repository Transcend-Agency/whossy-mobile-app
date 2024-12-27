import '../../../../../common/utils/index.dart';
import '../../model/core_settings_text.dart';

List<CoreSettingsText> coreSettingItems = [
  CoreSettingsText(value: CoreSettings.publicSearch),
  CoreSettingsText(value: CoreSettings.onlineStatus),
  CoreSettingsText(isPremium: true, value: CoreSettings.readReceipts),
];
