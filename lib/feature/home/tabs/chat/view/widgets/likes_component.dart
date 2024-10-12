import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../constants/index.dart';

class LikesComponent extends StatelessWidget {
  const LikesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          addWidth(14),
          GradientOutlineBox(
            child: Container(
              width: 132,
              height: 144,
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
                      child: Container(color: Colors.black.withOpacity(0)),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18.r),
                          gradient: AppColors.splashGradient,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.r,
                          vertical: 2.r,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '24',
                              style: TextStyles.hintThemeText.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: AppUtils.scale(10.sp) ?? 13.5.sp,
                              ),
                            ),
                            addWidth(4),
                            SvgPicture.asset(
                              AppAssets.love,
                              width: 17,
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
                        child: const GradientChip(text: 'Likes'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          addWidth(8),
          Container(
            width: 136,
            height: 148,
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
                  style: TextStyles.hintThemeText
                      .copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  '^_^',
                  style: TextStyles.hintThemeText
                      .copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
