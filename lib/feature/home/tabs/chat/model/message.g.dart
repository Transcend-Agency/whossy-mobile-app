// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String?,
      senderId: json['senderId'] as String?,
      message: json['message'] as String,
      timestamp: AppUtils.timestampFromJson(json['timestamp']),
      photos:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      localPhotos: (json['local_photos'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      status: $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
          MessageStatus.undelivered,
    );

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'senderId': instance.senderId,
    'message': instance.message,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('timestamp', AppUtils.timestampToJson(instance.timestamp));
  writeNotNull('local_photos', instance.localPhotos);
  writeNotNull('photos', instance.photos);
  writeNotNull('status', _$MessageStatusEnumMap[instance.status]);
  return val;
}

const _$MessageStatusEnumMap = {
  MessageStatus.sent: 'sent',
  MessageStatus.seen: 'seen',
  MessageStatus.undelivered: 'undelivered',
};
