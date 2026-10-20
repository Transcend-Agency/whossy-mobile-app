import '../../../../../common/utils/utils.dart';
import '../../model/core_settings_text.dart';

List<CoreSettingsText> coreSettingItems = [
  CoreSettingsText(value: CoreSettings.publicSearch),
  CoreSettingsText(value: CoreSettings.onlineStatus, isPremium: true),
  CoreSettingsText(value: CoreSettings.readReceipts),
];
