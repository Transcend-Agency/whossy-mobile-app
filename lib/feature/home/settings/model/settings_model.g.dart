// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map<String, dynamic> json) =>
    SettingsModel(
      incognito: json['incognito'] as bool?,
      incomingMessages: json['incoming_messages'] as bool?,
      hideBadge: json['hide_badge'] as bool?,
      publicSearch: json['public_search'] as bool?,
      onlineStatus: json['online_status'] as bool?,
      blocked:
          (json['blocked'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('incognito', instance.incognito);
  writeNotNull('incoming_messages', instance.incomingMessages);
  writeNotNull('hide_badge', instance.hideBadge);
  writeNotNull('public_search', instance.publicSearch);
  writeNotNull('online_status', instance.onlineStatus);
  writeNotNull('blocked', instance.blocked);
  return val;
}
