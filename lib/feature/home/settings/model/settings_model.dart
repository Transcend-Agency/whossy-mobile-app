import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/enum/enums.dart';

part 'settings_model.g.dart';

@JsonSerializable(
  includeIfNull: false,
)
class SettingsModel {
  bool? incognito;

  @JsonKey(name: 'incoming_messages')
  bool? incomingMessages;

  @JsonKey(name: 'hide_badge')
  bool? hideBadge;

  @JsonKey(name: 'public_search')
  bool? publicSearch;

  @JsonKey(name: 'online_status')
  bool? onlineStatus;

  List<String>? blocked;

  SettingsModel({
    this.incognito,
    this.incomingMessages,
    this.hideBadge,
    this.publicSearch,
    this.onlineStatus,
    this.blocked,
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);

  bool? getValue(CoreSettings setting) {
    final selectedValues = <CoreSettings, bool?>{
      CoreSettings.incognito: incognito,
      CoreSettings.incomingMessages: incomingMessages,
      CoreSettings.hideVerificationBadge: hideBadge,
      CoreSettings.publicSearch: publicSearch,
      CoreSettings.onlineStatus: onlineStatus,
    };

    return selectedValues[setting];
  }

  void updateSwitch(CoreSettings setting, bool newValue) {
    switch (setting) {
      case CoreSettings.incognito:
        incognito = newValue;
        break;
      case CoreSettings.incomingMessages:
        incomingMessages = newValue;
        break;
      case CoreSettings.hideVerificationBadge:
        hideBadge = newValue;
        break;
      case CoreSettings.publicSearch:
        publicSearch = newValue;
        break;
      case CoreSettings.onlineStatus:
        onlineStatus = newValue;
        break;
    }
  }

  void update({
    List<String>? blocked,
  }) {
    if (blocked != null) this.blocked = blocked;
  }
}
