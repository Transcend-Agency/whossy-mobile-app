import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/matching/view/widgets/match.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../notifications/view/widgets/notification_bell.dart';

class Matching extends StatelessWidget {
  const Matching({super.key});

  static String locationPermission = 'Location Permission';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding,
      child: SizedBox(
        width: 375.w,
        child: Column(
          children: [
            HeaderBar(
              customWidget: NotificationBell(
                onTap: () => Nav.push(context, const NotificationRoute()),
                rightSpacing: 0,
              ),
              child: const Logo(),
            ),
            Expanded(
              child: Consumer<LocationPermission>(
                builder: (_, permission, __) {
                  if (permission == LocationPermission.always ||
                      permission == LocationPermission.whileInUse) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Match(),
                    );
                  } else {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox.square(
                              dimension: 120.r,
                              child: Image.asset(AppAssets.block),
                            ),
                            Text(
                              'Location Permission Denied',
                              textAlign: TextAlign.center,
                              style: TextStyles.boldPrefText.copyWith(
                                fontSize: AppUtils.scale(13.sp) ?? 15.sp,
                              ),
                            ),
                            addHeight(4),
                            Text(
                              'We need access to your location to show nearby users',
                              textAlign: TextAlign.center,
                              style: TextStyles.bioText.copyWith(
                                fontSize: AppUtils.scale(11.5.sp),
                              ),
                            ),
                            addHeight(20),
                            GestureDetector(
                              onTap: openAppSettings,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.r,
                                  vertical: 6.r,
                                ),
                                decoration: BoxDecoration(
                                  gradient: AppColors.splashGradient,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                child: Text(
                                  'Open Settings',
                                  style: TextStyles.boldPrefText.copyWith(
                                    fontSize: AppUtils.scale(13.sp) ?? 15.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
