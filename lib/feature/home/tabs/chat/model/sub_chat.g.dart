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
      creditStatus: json['credit_status'] as String?,
      initiatorId: json['initiator_id'] as String?,
      holdPlacedAt: TimestampWrapper.timestampFromJson(json['hold_placed_at']),
      connectedAt: TimestampWrapper.timestampFromJson(json['connected_at']),
      creditHeld: json['credit_held'] as bool?,
      isUnlocked: json['is_unlocked'] as bool?,
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
      if (instance.creditStatus case final value?) 'credit_status': value,
      if (instance.initiatorId case final value?) 'initiator_id': value,
      if (TimestampWrapper.timestampToJson(instance.holdPlacedAt)
          case final value?)
        'hold_placed_at': value,
      if (TimestampWrapper.timestampToJson(instance.connectedAt)
          case final value?)
        'connected_at': value,
      if (instance.creditHeld case final value?) 'credit_held': value,
      if (instance.isUnlocked case final value?) 'is_unlocked': value,
    };
