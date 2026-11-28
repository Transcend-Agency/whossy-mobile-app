import 'package:firebase_messaging/firebase_messaging.dart';

/// Whether the phone lets Whossy show notifications.
enum NotificationAccess {
  /// Allowed.
  on,

  /// Never asked, so the system prompt can still be shown (iOS only:
  /// Android reports a prompt it has not shown yet as denied).
  notAsked,

  /// Denied. On Android the prompt may still appear once more; after that,
  /// and always on iOS, only the phone's settings can turn it back on.
  off;

  String get label => this == on ? 'On' : 'Off';
}

NotificationAccess notificationAccessFrom(AuthorizationStatus status) =>
    switch (status) {
      AuthorizationStatus.authorized ||
      AuthorizationStatus.provisional =>
        NotificationAccess.on,
      AuthorizationStatus.notDetermined => NotificationAccess.notAsked,
      AuthorizationStatus.denied => NotificationAccess.off,
    };
