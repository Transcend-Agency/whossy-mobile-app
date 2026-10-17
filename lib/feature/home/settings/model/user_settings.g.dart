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

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      if (instance.onlineStatus case final value?) 'online_status': value,
      if (instance.publicSearch case final value?) 'public_search': value,
      if (instance.readReceipts case final value?) 'read_receipts': value,
    };
