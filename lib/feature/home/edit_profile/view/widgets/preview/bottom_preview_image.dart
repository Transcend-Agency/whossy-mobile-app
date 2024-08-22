import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../constants/index.dart';

class BottomPreviewImage extends StatelessWidget {
  const BottomPreviewImage({super.key, this.showLess = false});

  final bool showLess;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF103B24),
                    border: Border.all(
                      color: const Color(0xFF09B45A),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: 2.h,
                    horizontal: 8.w,
                  ),
                  child: Text(
                    'Active',
                    style: TextStyles.prefText.copyWith(
                      color: const Color(0xFF09B45A),
                    ),
                  ),
                ),
                Text(
                  "  ~ 22 mi away",
                  style: TextStyles.prefText.copyWith(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            addHeight(2),
            Row(
              children: [
                Text(
                  'Stephanie, ',
                  style: TextStyles.profileHead.copyWith(
                    fontSize: AppUtils.scale(24.sp) ?? 26.sp,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '21',
                  style: TextStyles.profileHead.copyWith(
                    fontSize: AppUtils.scale(20.sp) ?? 22.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                addWidth(10),
                SvgPicture.asset(
                  AppAssets.tick,
                  width: 24,
                ),
              ],
            ),
            Text(
              AppStrings.profileBio,
              style: TextStyles.prefText.copyWith(
                color: Colors.white,
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, top: 8),
                  child: SvgPicture.asset(
                    AppAssets.interests,
                    width: 23,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: interestData.map((item) {
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                color: const Color(0xFF101010),
                              ),
                              padding: EdgeInsets.symmetric(
                                  vertical: 6.r, horizontal: 8.r),
                              child: Text(
                                item.name,
                                style: TextStyles.hintText.copyWith(
                                  fontSize: AppUtils.scale(10.sp),
                                  color: AppColors.hintTextColor,
                                ),
                              ),
                            ),
                            if (item.isSimilar)
                              Positioned(
                                top: -2,
                                right: -6,
                                child: SvgPicture.asset(
                                  AppAssets.star,
                                  width: 16.r,
                                ),
                              ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => showLess
                      ? Navigator.pop(context)
                      : Nav.push(context, const PreviewProfileMore()),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Transform.rotate(
                      angle: showLess ? math.pi : 0,
                      child: SvgPicture.asset(
                        AppAssets.down,
                        width: 21,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 20.h),
              child: PageIndicator(
                activePage: 1,
                pageNo: 6,
                height: 4,
                activeColor: Colors.white,
                inActiveColor: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final List<Interest> interestData = [
  Interest(name: "🎉  Just for fun"),
  Interest(name: "Netflix", isSimilar: true),
  Interest(name: "Travelling"),
  Interest(name: "Hiking", isSimilar: true),
  Interest(name: "Chilling"),
  Interest(name: "Skating"),
  Interest(name: "Dancing", isSimilar: true),
];

class Interest {
  final String name;
  final bool isSimilar;

  Interest({required this.name, this.isSimilar = false});
}
