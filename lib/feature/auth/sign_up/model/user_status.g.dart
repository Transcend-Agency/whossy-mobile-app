// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStatus _$UserStatusFromJson(Map<String, dynamic> json) => UserStatus(
      online: json['online'] as bool,
      lastSeen: AppUtils.timestampFromMilliseconds(
          (json['lastSeen'] as num?)?.toInt()),
    );

Map<String, dynamic> _$UserStatusToJson(UserStatus instance) =>
    <String, dynamic>{
      'online': instance.online,
      if (AppUtils.timestampToMilliseconds(instance.lastSeen) case final value?)
        'lastSeen': value,
    };
