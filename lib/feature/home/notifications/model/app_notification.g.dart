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
      type: json['type'] as String?,
      body: json['body'] as String?,
      timestamp: AppUtils.timestampFromJson(json['timestamp']),
      likerName: json['likerName'] as String?,
      likerProfilePicture: json['likerProfilePicture'] as String?,
      likedId: json['likedId'] as String?,
      likerId: json['likerId'] as String?,
      user1Id: json['user1_id'] as String?,
      user1Name: json['user1_name'] as String?,
      user1Pic: json['user1_pic'] as String?,
      user2Id: json['user2_id'] as String?,
      user2Name: json['user2_name'] as String?,
      user2Pic: json['user2_pic'] as String?,
      chatId: json['chatId'] as String?,
      senderId: json['senderId'] as String?,
      senderName: json['senderName'] as String?,
      senderProfilePicture: json['senderProfilePicture'] as String?,
      verificationStatus: json['verificationStatus'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );

Map<String, dynamic> _$AppNotificationToJson(AppNotification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'id': instance.id,
      'seen': instance.seen,
      if (instance.type case final value?) 'type': value,
      if (instance.body case final value?) 'body': value,
      if (AppUtils.timestampToJson(instance.timestamp) case final value?)
        'timestamp': value,
      if (instance.likerName case final value?) 'likerName': value,
      if (instance.likerProfilePicture case final value?)
        'likerProfilePicture': value,
      if (instance.likedId case final value?) 'likedId': value,
      if (instance.likerId case final value?) 'likerId': value,
      if (instance.user1Id case final value?) 'user1_id': value,
      if (instance.user1Name case final value?) 'user1_name': value,
      if (instance.user1Pic case final value?) 'user1_pic': value,
      if (instance.user2Id case final value?) 'user2_id': value,
      if (instance.user2Name case final value?) 'user2_name': value,
      if (instance.user2Pic case final value?) 'user2_pic': value,
      if (instance.chatId case final value?) 'chatId': value,
      if (instance.senderId case final value?) 'senderId': value,
      if (instance.senderName case final value?) 'senderName': value,
      if (instance.senderProfilePicture case final value?)
        'senderProfilePicture': value,
      if (instance.verificationStatus case final value?)
        'verificationStatus': value,
      if (instance.rejectionReason case final value?) 'rejectionReason': value,
    };
