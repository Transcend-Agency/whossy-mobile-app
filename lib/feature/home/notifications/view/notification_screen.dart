import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../constants/index.dart';
import '../model/sample_data.dart';
import 'widgets/_.dart';

@RoutePage()
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const count = 300;
    return AppScaffold(
      appBar: CustomAppBar(
        addBarHeight: 4,
        title: 'Notifications',
        color: Colors.white,
        action: GestureDetector(
          onTap: () {},
          child: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  child: SvgPicture.asset(AppAssets.bell, width: 16.r),
                ),
                Positioned(
                  right: count < 10 ? 0 : (count < 100 ? -3 : 2),
                  top: count > 100 ? 2 : null,
                  child: notificationDot(count),
                )
              ],
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return NotificationTile(notification: notifications[index]);
        },
      ),
    );
  }
}

/*
const Center(
        child: EmptyDataBox(
          key: ValueKey('empty'),
          image: AppAssets.noNotifications,
          text: 'No new notification',
          imageSize: 100,
          spacing: 10,
        ),
      ),
 */
