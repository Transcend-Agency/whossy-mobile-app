// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
      incomingMessages: json['incoming_messages'] as bool? ?? true,
      onlineStatus: json['online_status'] as bool? ?? false,
      publicSearch: json['public_search'] as bool? ?? false,
      readReceipts: json['read_receipts'] as bool? ?? false,
    );

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('incoming_messages', instance.incomingMessages);
  writeNotNull('online_status', instance.onlineStatus);
  writeNotNull('public_search', instance.publicSearch);
  writeNotNull('read_receipts', instance.readReceipts);
  return val;
}
