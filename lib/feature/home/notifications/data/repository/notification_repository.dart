import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../tabs/matching/model/user_profile.dart';
import '../../model/app_notification.dart';

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

  /// Stream that returns the count of unread notifications
  Stream<int> unreadNotificationCount() {
    return path()
        .where('seen', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Fetch a user profile by user ID
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      final doc = await _users.doc(userId).get();
      if (doc.exists) {
        return UserProfile.fromJson(doc.data()!);
      } else {
        log('User profile not found for ID: $userId');
        return null;
      }
    } catch (e) {
      log('Error fetching user profile: $e');
      return null;
    }
  }
}
