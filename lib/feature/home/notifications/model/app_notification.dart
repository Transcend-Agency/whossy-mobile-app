import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/index.dart';

part 'app_notification.g.dart';
//
// class AppNotification {
//   final NotificationType type;
//   final String title;
//   final String subtitle;
//   final DateTime timestamp;
//   final String? imageUrl;
//   final bool seen;
//
//   AppNotification({
//     required this.type,
//     required this.title,
//     required this.subtitle,
//     required this.timestamp,
//     this.imageUrl,
//     this.seen = false,
//   });
// }

@JsonSerializable()
class AppNotification {
  final String title;
  final String id;
  final bool seen;
  final String? likedId;
  final String? likerId;

  @JsonKey(
    fromJson: AppUtils.timestampFromJson,
    toJson: AppUtils.timestampToJson,
  )
  final Timestamp? timestamp;

  final String? likerName;
  final String? likerProfilePicture;

  @JsonKey(name: 'user1_id')
  final String? user1Id;

  @JsonKey(name: 'user1_name')
  final String? user1Name;

  @JsonKey(name: 'user1_pic')
  final String? user1Pic;

  @JsonKey(name: 'user2_id')
  final String? user2Id;

  @JsonKey(name: 'user2_name')
  final String? user2Name;

  @JsonKey(name: 'user2_pic')
  final String? user2Pic;

  AppNotification({
    required this.title,
    required this.id,
    required this.seen,
    this.likedId,
    this.likerId,
    this.timestamp,
    this.likerName,
    this.likerProfilePicture,
    this.user1Id,
    this.user1Name,
    this.user1Pic,
    this.user2Id,
    this.user2Name,
    this.user2Pic,
  });

  /// Factory method to create an instance from JSON
  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  /// Method to convert the instance into JSON
  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  /// Internal method to determine the notification type
  NotificationType get notificationType {
    switch (title.toLowerCase()) {
      case "like":
        return NotificationType.like;
      case "match":
        return NotificationType.match;
      case "message":
        return NotificationType.message;
      default:
        return NotificationType.unknown;
    }
  }
}
