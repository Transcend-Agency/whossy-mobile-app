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
      isUnlocked: json['is_unlocked'] as bool?,
    );

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      'participants': instance.participants,
      'last_message': instance.lastMessage,
      if (TimestampWrapper.timestampToJson(instance.lastMessageTimestamp)
          case final value?)
        'last_message_timestamp': value,
      if (TimestampWrapper.timestampToJson(instance.unlockTime)
          case final value?)
        'unlock_time': value,
      if (TimestampWrapper.timestampToJson(instance.expirationTime)
          case final value?)
        'expiration_time': value,
      if (_$MessageStatusEnumMap[instance.lastMessageStatus] case final value?)
        'status': value,
      if (instance.lastMessageId case final value?) 'last_message_id': value,
      if (instance.isSeenByReceiver case final value?)
        'is_seen_by_receiver': value,
      if (instance.isUnlocked case final value?) 'is_unlocked': value,
    };

const _$MessageStatusEnumMap = {
  MessageStatus.sent: 'sent',
  MessageStatus.seen: 'seen',
  MessageStatus.undelivered: 'undelivered',
};
