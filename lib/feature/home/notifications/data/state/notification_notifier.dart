import 'package:flutter/foundation.dart';

import '../../model/app_notification.dart';
import '../repository/notification_repository.dart';

class NotificationNotifier extends ChangeNotifier {
  final _notificationRepo = NotificationRepository();

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
}
