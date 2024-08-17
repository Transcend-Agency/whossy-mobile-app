import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';

class ProfileCustomButton extends StatelessWidget {
  const ProfileCustomButton({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.containerColor,
    required this.textColor,
  });

  final String imagePath;
  final String title;
  final String subTitle;
  final Color containerColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.all(12.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 40.r,
              child: Image.asset(imagePath),
            ),
            addWidth(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyles.whossyGuideText,
                ),
                Text(
                  subTitle,
                  style: TextStyles.underlineWhossyGuide.copyWith(
                    color: textColor,
                    decorationColor: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox.square(
        dimension: 130.r,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox.square(
                    dimension: 120.r,
                    child: Transform.rotate(
                      angle: pi,
                      child: const CircularProgressIndicator(
                        value: 0.25,
                        strokeCap: StrokeCap.round,
                        strokeWidth: 6,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor),
                        backgroundColor: AppColors.selectedFieldColor,
                      ),
                    ),
                  ),
                  SizedBox.square(
                    dimension: 115.r,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset('assets/images/sp_1_2.png'),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -6,
              top: -8,
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(4),
                  child: SvgPicture.asset(
                    AppAssets.edit,
                    height: 40.r,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class WhossySafetyGuide extends StatelessWidget {
  const WhossySafetyGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.inputBackGround,
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.guide,
            width: 20.r,
          ),
          addWidth(8),
          Text(
            'Whossy Safety Guide',
            style: TextStyles.whossyGuideText,
          ),
        ],
      ),
    );
  }
}
