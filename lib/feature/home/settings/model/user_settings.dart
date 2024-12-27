import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/enum/enums.dart';

part 'user_settings.g.dart';

@JsonSerializable()
class UserSettings {
  @JsonKey(name: 'online_status')
  bool? onlineStatus;

  @JsonKey(name: 'public_search')
  bool? publicSearch;

  @JsonKey(name: 'read_receipts')
  bool? readReceipts;

  UserSettings({
    this.onlineStatus = true,
    this.publicSearch = true,
    this.readReceipts = true,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);

  bool? getValue(CoreSettings setting) {
    final selectedValues = <CoreSettings, bool?>{
      CoreSettings.readReceipts: readReceipts,
      CoreSettings.publicSearch: publicSearch,
      CoreSettings.onlineStatus: onlineStatus,
    };

    return selectedValues[setting];
  }

  void updateSwitch(CoreSettings setting, bool newValue) {
    switch (setting) {
      case CoreSettings.publicSearch:
        publicSearch = newValue;
        break;
      case CoreSettings.readReceipts:
        readReceipts = newValue;
        break;
      case CoreSettings.onlineStatus:
        onlineStatus = newValue;
        break;
    }
  }
}
