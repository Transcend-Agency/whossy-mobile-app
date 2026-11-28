import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:whossy_app/feature/home/tabs/likes_and_match/data/repository/likes_repository.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../model/app_notification.dart';
import '../repository/notification_repository.dart';

class NotificationNotifier extends ChangeNotifier {
  final _notificationRepo = NotificationRepository();
  final _likesRepo = LikesRepository();

  Stream<List<AppNotification>> get notificationStream {
    return _notificationRepo.getAppNotifications();
  }

  Future<void> updateNotificationStatus(AppNotification notification) async {
    return _notificationRepo.updateNotificationStatus(notification);
  }

  Stream<bool> get hasUnreadNotificationsStream {
    return _notificationRepo.hasUnreadNotifications();
  }

  Stream<int> get unreadNotificationCountStream {
    return _notificationRepo.unreadNotificationCount();
  }

  Future<UserProfile?> getProfileData(String id) {
    return _notificationRepo.getUserProfile(id);
  }

  /// Whether the signed-in user has already liked [id], so the profile
  /// opened from a notification doesn't offer a like that already exists.
  Future<bool> hasLiked(String id) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return false;
    return _likesRepo.hasLiked(likerId: uid, likedId: id);
  }
}
