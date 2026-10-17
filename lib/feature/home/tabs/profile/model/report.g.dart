// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Report _$ReportFromJson(Map<String, dynamic> json) => Report(
      id: json['id'] as String?,
      message: json['message'] as String,
      reportedId: json['reportedId'] as String?,
      reportedName: json['reportedName'] as String,
      reporterId: json['reporterId'] as String?,
      reporterName: json['reporterName'] as String?,
      timestamp: TimestampWrapper.timestampFromJson(json['timestamp']),
    );

Map<String, dynamic> _$ReportToJson(Report instance) => <String, dynamic>{
      'message': instance.message,
      'reportedId': instance.reportedId,
      'reportedName': instance.reportedName,
      if (instance.reporterId case final value?) 'reporterId': value,
      if (instance.reporterName case final value?) 'reporterName': value,
      if (TimestampWrapper.timestampToJson(instance.timestamp)
          case final value?)
        'timestamp': value,
    };
