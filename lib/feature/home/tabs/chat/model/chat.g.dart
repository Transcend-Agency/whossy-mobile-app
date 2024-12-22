// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) => Chat(
      id: json['id'] as String?,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      lastMessage: json['last_message'] as String,
      lastMessageTimestamp:
          TimestampWrapper.timestampFromJson(json['last_message_timestamp']),
      lastMessageStatus:
          $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
              MessageStatus.undelivered,
      lastMessageId: json['last_message_id'] as String?,
      isSeenByReceiver: json['is_seen_by_receiver'] as bool?,
      unlockTime: TimestampWrapper.timestampFromJson(json['unlock_time']),
      expirationTime:
          TimestampWrapper.timestampFromJson(json['expiration_time']),
    );

Map<String, dynamic> _$ChatToJson(Chat instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['participants'] = instance.participants;
  val['last_message'] = instance.lastMessage;
  writeNotNull('last_message_timestamp',
      TimestampWrapper.timestampToJson(instance.lastMessageTimestamp));
  writeNotNull(
      'unlock_time', TimestampWrapper.timestampToJson(instance.unlockTime));
  writeNotNull('expiration_time',
      TimestampWrapper.timestampToJson(instance.expirationTime));
  writeNotNull('status', _$MessageStatusEnumMap[instance.lastMessageStatus]);
  writeNotNull('last_message_id', instance.lastMessageId);
  writeNotNull('is_seen_by_receiver', instance.isSeenByReceiver);
  return val;
}

const _$MessageStatusEnumMap = {
  MessageStatus.sent: 'sent',
  MessageStatus.seen: 'seen',
  MessageStatus.undelivered: 'undelivered',
};
