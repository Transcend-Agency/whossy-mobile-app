// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String?,
      senderId: json['sender_id'] as String?,
      message: json['message'] as String?,
      timestamp: TimestampWrapper.timestampFromJson(json['timestamp']),
      photo: json['photo'] as String?,
      localPhoto: json['local_photo'] as String?,
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.undelivered,
      isSenderBlocked: json['sender_id_blocked'] as bool? ?? false,
    );

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      if (instance.message case final value?) 'message': value,
      if (TimestampWrapper.timestampToJson(instance.timestamp)
          case final value?)
        'timestamp': value,
      if (instance.localPhoto case final value?) 'local_photo': value,
      if (instance.photo case final value?) 'photo': value,
      if (_$MessageStatusEnumMap[instance.status] case final value?)
        'status': value,
      'sender_id_blocked': instance.isSenderBlocked,
    };

const _$MessageStatusEnumMap = {
  MessageStatus.sent: 'sent',
  MessageStatus.seen: 'seen',
  MessageStatus.undelivered: 'undelivered',
};
