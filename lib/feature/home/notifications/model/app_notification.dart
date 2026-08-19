import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/utils.dart';

part 'app_notification.g.dart';

@JsonSerializable()
class AppNotification {
  final String title;
  final String id;
  final bool seen;

  // Machine-readable discriminant written by the Cloud Function triggers
  // (functions/src/notifications.ts, shared with web) — 'like' | 'match' |
  // 'message' | 'verification'. Falls back to parsing `title` only for
  // documents that predate this field (there shouldn't be any live ones,
  // since nothing wrote to this collection before those triggers existed).
  @JsonKey(name: 'type')
  final String? type;

  final String? body;

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

  // Fields for Message Notification
  @JsonKey(name: 'chatId')
  final String? chatId;

  @JsonKey(name: 'senderId')
  final String? senderId;

  @JsonKey(name: 'senderName')
  final String? senderName;

  @JsonKey(name: 'senderProfilePicture')
  final String? senderProfilePicture;

  // Fields for Verification-decision Notification
  @JsonKey(name: 'verificationStatus')
  final String? verificationStatus;

  @JsonKey(name: 'rejectionReason')
  final String? rejectionReason;

  AppNotification({
    required this.title,
    required this.id,
    required this.seen,
    this.type,
    this.body,
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
    this.chatId,
    this.senderId,
    this.senderName,
    this.senderProfilePicture,
    this.verificationStatus,
    this.rejectionReason,
  });

  /// Factory method to create an instance from JSON
  factory AppNotification.fromJson(Map<String, dynamic> json) =>
      _$AppNotificationFromJson(json);

  /// Method to convert the instance into JSON
  Map<String, dynamic> toJson() => _$AppNotificationToJson(this);

  /// **Determines the notification type** — reads the `type` field written
  /// by the Cloud Function triggers; falls back to the title heuristic only
  /// for a document with no `type` at all.
  NotificationType get notificationType {
    switch (type) {
      case 'like':
        return NotificationType.like;
      case 'match':
        return NotificationType.match;
      case 'message':
        return NotificationType.message;
      case 'verification':
        return NotificationType.verification;
    }

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
  /// - **Message Notification** → `senderId`
  /// - **Verification** → `null` (not about another user)
  String? get interactingUserId {
    switch (notificationType) {
      case NotificationType.like:
        return likerId;
      case NotificationType.match:
        return user1Id;
      case NotificationType.message:
        return senderId;
      case NotificationType.verification:
      case NotificationType.unknown:
        return null;
    }
  }
}
