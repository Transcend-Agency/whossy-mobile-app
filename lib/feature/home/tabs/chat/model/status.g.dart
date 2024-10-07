// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Status _$StatusFromJson(Map<String, dynamic> json) => Status(
      lastSeen: (json['lastSeen'] as num).toInt(),
      online: json['online'] as bool,
    );

Map<String, dynamic> _$StatusToJson(Status instance) => <String, dynamic>{
      'lastSeen': instance.lastSeen,
      'online': instance.online,
    };
