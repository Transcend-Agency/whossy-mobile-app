// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reply_to.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReplyTo _$ReplyToFromJson(Map<String, dynamic> json) => ReplyTo(
      id: json['id'] as String,
      senderId: json['sender_id'] as String,
      message: json['message'] as String?,
      hasPhoto: json['has_photo'] as bool? ?? false,
    );

Map<String, dynamic> _$ReplyToToJson(ReplyTo instance) => <String, dynamic>{
      'id': instance.id,
      'sender_id': instance.senderId,
      if (instance.message case final value?) 'message': value,
      'has_photo': instance.hasPhoto,
    };
