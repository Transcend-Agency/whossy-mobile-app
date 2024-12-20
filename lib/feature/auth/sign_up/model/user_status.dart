import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
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

  String getLastSeen(Timestamp currentTime) {
    final time = lastSeen!.toDate();
    final currentDateTime = currentTime.toDate();
    final difference = currentDateTime.difference(time);

    if (difference.inHours >= 48 || (currentDateTime.day - time.day >= 2)) {
      final formatter = DateFormat('MMM dd, yyyy');
      return 'last seen ${formatter.format(time)}';
    } else if (difference.inHours >= 24) {
      final formatter = DateFormat("h:mm a");
      return 'Yesterday at ${formatter.format(time)}';
    } else if (difference.inHours >= 1) {
      return 'last seen ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes >= 1) {
      return 'last seen ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'last seen just now';
    }
  }
}
