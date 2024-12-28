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

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'sender_id': instance.senderId,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('message', instance.message);
  writeNotNull(
      'timestamp', TimestampWrapper.timestampToJson(instance.timestamp));
  writeNotNull('local_photo', instance.localPhoto);
  writeNotNull('photo', instance.photo);
  writeNotNull('status', _$MessageStatusEnumMap[instance.status]);
  val['sender_id_blocked'] = instance.isSenderBlocked;
  return val;
}

const _$MessageStatusEnumMap = {
  MessageStatus.sent: 'sent',
  MessageStatus.seen: 'seen',
  MessageStatus.undelivered: 'undelivered',
};
