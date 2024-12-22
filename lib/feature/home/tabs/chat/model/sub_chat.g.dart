// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubChat _$SubChatFromJson(Map<String, dynamic> json) => SubChat(
      id: json['id'] as String?,
      lastMessageId: json['last_message_id'] as String?,
      unlockTime: TimestampWrapper.timestampFromJson(json['unlock_time']),
      expirationTime:
          TimestampWrapper.timestampFromJson(json['expiration_time']),
    );

Map<String, dynamic> _$SubChatToJson(SubChat instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull(
      'unlock_time', TimestampWrapper.timestampToJson(instance.unlockTime));
  writeNotNull('expiration_time',
      TimestampWrapper.timestampToJson(instance.expirationTime));
  writeNotNull('last_message_id', instance.lastMessageId);
  return val;
}
