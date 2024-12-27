// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      onlineStatus: json['online_status'] as bool? ?? true,
      publicSearch: json['public_search'] as bool? ?? true,
      readReceipts: json['read_receipts'] as bool? ?? true,
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('online_status', instance.onlineStatus);
  writeNotNull('public_search', instance.publicSearch);
  writeNotNull('read_receipts', instance.readReceipts);
  return val;
}
