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

Map<String, dynamic> _$UserStatusToJson(UserStatus instance) {
  final val = <String, dynamic>{
    'online': instance.online,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('lastSeen', AppUtils.timestampToMilliseconds(instance.lastSeen));
  return val;
}
