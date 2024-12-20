import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/feature/home/notifications/model/app_notification.dart';

class NotificationRepository {
  final _users = FirebaseFirestore.instance.collection('users');

  NotificationRepository();

  /// Get the path to the notifications collection for a specific user
  CollectionReference<Map<String, dynamic>> path() => _users
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notifications');

  /// Fetch a stream of notifications for the user
  Stream<List<AppNotification>> getAppNotifications() {
    return path().orderBy('timestamp', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => AppNotification.fromJson(doc.data()),
              )
              .toList(),
        );
  }

  /// Update notification status to seen
  Future<void> updateNotificationStatus(AppNotification notification) async {
    try {
      await path().doc(notification.id).update({'seen': true});
    } catch (e) {
      log('Error updating notification status: $e');
    }
  }

  /// Stream that returns a bool, indicating if there's any unseen notification
  Stream<bool> hasUnreadNotifications() {
    return path()
        .where('seen', isEqualTo: false)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  Stream<int> unreadNotificationCount() {
    return path()
        .where('seen', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
