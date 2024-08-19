import 'package:json_annotation/json_annotation.dart';

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

  void update({
    bool? incognito,
    bool? incomingMessages,
    bool? hideBadge,
    bool? publicSearch,
    bool? onlineStatus,
    List<String>? blocked,
  }) {
    if (incognito != null) this.incognito = incognito;
    if (incomingMessages != null) this.incomingMessages = incomingMessages;
    if (hideBadge != null) this.hideBadge = hideBadge;
    if (publicSearch != null) this.publicSearch = publicSearch;
    if (onlineStatus != null) this.onlineStatus = onlineStatus;
    if (blocked != null) this.blocked = blocked;
  }
}
