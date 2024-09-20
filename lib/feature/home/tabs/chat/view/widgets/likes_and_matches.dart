import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../constants/index.dart';

class LikesAndMatches extends StatelessWidget {
  const LikesAndMatches({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          addWidth(12),
          GradientOutlineBox(
            child: Container(
              height: 142.r,
              width: 130.r,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: Colors.white, width: 3.r),
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'assets/images/sp_1_1.png',
                      fit: BoxFit.cover,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.black.withOpacity(0),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.r),
                          gradient: AppColors.splashGradient,
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 2.h),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '24',
                              style: TextStyles.boldPrefText
                                  .copyWith(color: Colors.white),
                            ),
                            addWidth(4),
                            SvgPicture.asset(
                              AppAssets.love,
                              width: 18.r,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Transform(
                              transform: Matrix4.skewX(-.3),
                              alignment: Alignment.center,
                              child: Container(
                                width: 54.w,
                                height: 22.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  gradient: AppColors.splashGradient,
                                ),
                              ),
                            ),
                            Text(
                              'Likes',
                              style: TextStyles.boldPrefText
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          addWidth(12),
          Container(
            width: 136.r,
            height: 148.r,
            decoration: BoxDecoration(
              color: AppColors.listTileColor,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 6.w),
                  child: Image.asset(AppAssets.noMatches, height: 52),
                ),
                addHeight(4),
                Text(
                  'No match yet',
                  style: TextStyles.boldPrefText
                      .copyWith(color: AppColors.hintTextColor),
                ),
                Text(
                  '^_^',
                  style: TextStyles.boldPrefText
                      .copyWith(color: AppColors.hintTextColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GradientOutlineBox extends StatelessWidget {
  final Widget child;

  const GradientOutlineBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: AppColors.splashGradient,
            borderRadius: BorderRadius.circular(18.r),
          ),
          width: 136.r,
          height: 148.r,
        ),
        child,
      ],
    );
  }
}
