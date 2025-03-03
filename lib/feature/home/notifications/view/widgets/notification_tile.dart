import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // Import flutter_hooks
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart'; // Import the visibility_detector package
import 'package:whossy_app/common/components/components.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/feature/home/notifications/data/state/notification_notifier.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../model/app_notification.dart';

class NotificationTile extends HookWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isVisible = useState(false);
    final isUpdating = useState(false);

    String? imageUrl1 = notification.user1Pic;
    String? imageUrl2 = notification.user2Pic;
    String? profilePic = notification.likerProfilePicture;

    // Effect to update notification when tile becomes visible
    useEffect(() {
      // Check the condition
      if (isVisible.value && !isUpdating.value && !notification.seen) {
        _updateNotificationStatus(isUpdating, useContext());
      }

      return null; // Cleanup (if necessary, null for no cleanup)
    }, [isVisible.value]);

    return VisibilityDetector(
      key: Key(notification.id),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction > 0.3 && !isUpdating.value) {
          isVisible.value = true;
        }
      },
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            Column(
              children: [
                ListTile(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  contentPadding:
                      EdgeInsets.only(top: 14.r, left: 18.r, right: 18.r),
                  title: Row(
                    children: [
                      Text(
                        _getNotificationTitle,
                        style: TextStyles.profileHead.copyWith(
                          fontSize: AppUtils.scale(11.5.sp) ?? 16,
                        ),
                      ),
                      if (!notification.seen)
                        Container(
                          margin: EdgeInsets.only(left: 8.r),
                          width: 6.r,
                          height: 6.r,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  subtitle: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      addHeight(3),
                      Text(
                        _getNotificationSubtitle(),
                        style: TextStyles.hintThemeText.copyWith(
                          fontSize: AppUtils.scale(9.5.sp) ?? 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      addHeight(2),
                    ],
                  ),
                  trailing: notification.notificationType ==
                          NotificationType.match
                      ? Stack(
                          children: [
                            if (imageUrl1 != null)
                              Transform.translate(
                                offset: const Offset(-7, -8),
                                child: Transform.rotate(
                                  angle: -10 * pi / 180,
                                  child: RectangleAppAvatar(
                                    imageUrl: imageUrl1,
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                            if (imageUrl2 != null)
                              Transform.translate(
                                offset: const Offset(0, 5),
                                child: Transform.rotate(
                                  angle: 10 * pi / 180,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: RectangleAppAvatar(
                                      imageUrl: imageUrl2,
                                      width: 41,
                                      height: 41,
                                    ),
                                  ),
                                ),
                              )
                          ],
                        )
                      : Transform.rotate(
                          angle: 10 * pi / 180,
                          child: RectangleAppAvatar(
                            imageUrl: profilePic ?? "",
                            width: 46,
                            height: 46,
                          ),
                        ),
                ),
                addHeight(8),
                Padding(
                  padding: pagePadding,
                  child: const AppDivider(),
                ),
              ],
            ),
            if (!notification.seen)
              Positioned.fill(
                child: Container(
                  color: AppColors.primaryColor.withOpacity(0.05),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String get _getNotificationTitle => notification.notificationType.value;

  // Method to get the subtitle based on the notification type
  String _getNotificationSubtitle() {
    switch (notification.notificationType) {
      case NotificationType.like:
        String liker = notification.likerName == null
            ? "Someone"
            : notification.likerName!;

        bool showProfileCheck = Random().nextBool();
        return showProfileCheck
            ? '$liker is interested in you'
            : '$liker liked your profile!';

      case NotificationType.match:
        return 'You have a new match with ${notification.user1Name ?? notification.user2Name}';

      case NotificationType.message:
        return 'You received a new message from ${notification.likerName ?? notification.user1Name}';

      default:
        return '';
    }
  }

  // Function to update the notification status after a 2-second delay
  Future<void> _updateNotificationStatus(
    ValueNotifier<bool> isUpdating,
    BuildContext context,
  ) async {
    isUpdating.value = true;

    await Future.delayed(const Duration(seconds: 2));

    if (context.mounted) {
      await context
          .read<NotificationNotifier>()
          .updateNotificationStatus(notification);
    }

    // Mark as seen and prevent further updates
    isUpdating.value = false;
  }
}
