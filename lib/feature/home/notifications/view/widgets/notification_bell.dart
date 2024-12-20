import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';

class NotificationBell extends HookWidget {
  const NotificationBell({super.key, this.onTap, this.rightSpacing = 16});

  final VoidCallback? onTap;
  final double rightSpacing;

  @override
  Widget build(BuildContext context) {
    final notificationNotifier = context.watch<NotificationNotifier>();

    final unreadNotificationsCountStream = useMemoized(
      () => notificationNotifier.unreadNotificationCountStream,
      [],
    );

    final unreadNotificationsCount = useStream(unreadNotificationsCountStream);

    final count = unreadNotificationsCount.data ?? 0;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: rightSpacing.w),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(AppAssets.bell, width: 16.r),
            ),
            // Show the dot if count > 0
            if (count > 0)
              Positioned(
                right: count < 10 ? 0 : (count < 100 ? -3 : 2),
                top: count > 100 ? 2 : null,
                child: notificationDot(count),
              ),
          ],
        ),
      ),
    );
  }
}
