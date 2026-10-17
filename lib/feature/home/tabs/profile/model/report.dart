import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../../common/utils/utils.dart';

part 'report.g.dart';

@JsonSerializable()
class Report {
  @JsonKey(
    includeToJson: false,
  )
  final String? id;
  final String message;
  final String reportedId;
  final String reportedName;
  final String? reporterId;
  final String? reporterName;

  @JsonKey(
    fromJson: TimestampWrapper.timestampFromJson,
    toJson: TimestampWrapper.timestampToJson,
  )
  final TimestampWrapper? timestamp;

  Report({
    String? id,
    required this.message,
    String? reportedId,
    required this.reportedName,
    this.reporterId,
    String? reporterName,
    TimestampWrapper? timestamp,
  })  : id = id ??
            AppUtils.generateCombinedId(reporterId ?? '', reportedId ?? ''),
        timestamp = timestamp ?? TimestampWrapper(FieldValue.serverTimestamp()),
        reporterName = reporterName ?? '',
        reportedId = reportedId ?? '';

  // FromJson and ToJson
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}
