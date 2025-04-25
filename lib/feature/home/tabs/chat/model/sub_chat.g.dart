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

Map<String, dynamic> _$SubChatToJson(SubChat instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (TimestampWrapper.timestampToJson(instance.unlockTime)
          case final value?)
        'unlock_time': value,
      if (TimestampWrapper.timestampToJson(instance.expirationTime)
          case final value?)
        'expiration_time': value,
      if (instance.lastMessageId case final value?) 'last_message_id': value,
    };
