import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/index.dart';

part 'user_status.g.dart';

@JsonSerializable()
class UserStatus {
  final bool online;

  @JsonKey(
    name: 'lastSeen',
    fromJson: AppUtils.timestampFromMilliseconds,
    toJson: AppUtils.timestampToMilliseconds,
  )
  final Timestamp? lastSeen;

  UserStatus({
    required this.online,
    this.lastSeen,
  });

  factory UserStatus.fromJson(Map<String, dynamic> json) =>
      _$UserStatusFromJson(json);

  Map<String, dynamic> toJson() => _$UserStatusToJson(this);

  @override
  String toString() {
    return 'online: $online, lastSeen: ${lastSeen?.toDate()}';
  }
}
