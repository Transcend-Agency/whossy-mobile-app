import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../../model/app_notification.dart';

class NotificationTile extends StatelessWidget {
  final AppNotification notification;

  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    String url1 =
        "https://images.unsplash.com/photo-1730405704088-3d8f36e32b62?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    String url2 =
        "https://images.unsplash.com/photo-1730461749346-d75ee4d30aa1?q=80&w=1374&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    String url3 =
        "https://images.unsplash.com/photo-1730304539413-02706e6705db?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
    return Stack(
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
                    notification.title,
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
                    notification.subtitle,
                    style: TextStyles.hintThemeText.copyWith(
                      fontSize: AppUtils.scale(9.5.sp) ?? 13.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  addHeight(2),
                ],
              ),
              trailing: notification.type == NotificationType.match
                  ? Stack(
                      children: [
                        Transform.translate(
                          offset: const Offset(-7, -8),
                          child: Transform.rotate(
                            angle: -10 * pi / 180,
                            child: RectangleAppAvatar(
                              imageUrl: url1,
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
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
                                imageUrl: url2,
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
                        imageUrl: url3,
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
    );
  }
}
