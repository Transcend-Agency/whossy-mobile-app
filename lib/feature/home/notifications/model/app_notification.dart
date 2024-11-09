import 'package:whossy_app/common/utils/enum/enums.dart';

class AppNotification {
  final NotificationType type;
  final String title;
  final String subtitle;
  final DateTime timestamp;
  final String? imageUrl;
  final bool seen;

  AppNotification({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timestamp,
    this.imageUrl,
    this.seen = false,
  });
}
