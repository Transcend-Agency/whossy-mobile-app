import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/index.dart';

part 'app_notification.g.dart';

@JsonSerializable()
class AppNotification {
  final String title;
  final String id;
  final bool seen;

  @JsonKey(
    fromJson: AppUtils.timestampFromJson,
    toJson: AppUtils.timestampToJson,
  )
  final Timestamp? timestamp;

  // Fields for Like Notification
  final String? likerName;
  final String? likerProfilePicture;
  final String? likedId;
  final String? likerId;

  // Fields for Match Notification
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
    this.timestamp,
    this.likerName,
    this.likerProfilePicture,
    this.likedId,
    this.likerId,
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

  /// **Determines the notification type based on the title**
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

  /// **Returns the ID of the person interacting with the user**
  ///
  /// - **Like Notification** → `likerId`
  /// - **Match Notification** → `user1Id`
  /// - **Others** → `null`
  String? get interactingUserId {
    switch (notificationType) {
      case NotificationType.like:
        return likerId;
      case NotificationType.match:
        return user1Id;
      default:
        return null;
    }
  }
}
