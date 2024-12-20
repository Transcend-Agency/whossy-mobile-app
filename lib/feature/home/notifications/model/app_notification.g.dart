// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppNotification _$AppNotificationFromJson(Map<String, dynamic> json) =>
    AppNotification(
      title: json['title'] as String,
      id: json['id'] as String,
      seen: json['seen'] as bool,
      likedId: json['likedId'] as String?,
      likerId: json['likerId'] as String?,
      timestamp: AppUtils.timestampFromJson(json['timestamp']),
      likerName: json['likerName'] as String?,
      likerProfilePicture: json['likerProfilePicture'] as String?,
      user1Id: json['user1_id'] as String?,
      user1Name: json['user1_name'] as String?,
      user1Pic: json['user1_pic'] as String?,
      user2Id: json['user2_id'] as String?,
      user2Name: json['user2_name'] as String?,
      user2Pic: json['user2_pic'] as String?,
    );

Map<String, dynamic> _$AppNotificationToJson(AppNotification instance) {
  final val = <String, dynamic>{
    'title': instance.title,
    'id': instance.id,
    'seen': instance.seen,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('likedId', instance.likedId);
  writeNotNull('likerId', instance.likerId);
  writeNotNull('timestamp', AppUtils.timestampToJson(instance.timestamp));
  writeNotNull('likerName', instance.likerName);
  writeNotNull('likerProfilePicture', instance.likerProfilePicture);
  writeNotNull('user1_id', instance.user1Id);
  writeNotNull('user1_name', instance.user1Name);
  writeNotNull('user1_pic', instance.user1Pic);
  writeNotNull('user2_id', instance.user2Id);
  writeNotNull('user2_name', instance.user2Name);
  writeNotNull('user2_pic', instance.user2Pic);
  return val;
}
