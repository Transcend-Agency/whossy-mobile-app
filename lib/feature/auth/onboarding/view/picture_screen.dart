import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';

class PictureScreen extends StatefulWidget {
  final int pageIndex;

  const PictureScreen({super.key, required this.pageIndex});

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen>
    with AutomaticKeepAliveClientMixin<PictureScreen> {
  final double rotationAngle = 5 * math.pi / 180;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Share a snapshot of you",
          subtitle: "Add at least 2 recent photos of yourself 🤗",
        ),
        addHeight(8),
        Text(
          "Hint: Using your best photo could give a great first "
          "impression and the beginning of something great",
          style: TextStyles.hintText.copyWith(
            fontSize: AppUtils.scale(10.5.sp),
          ),
        ),
        addHeight(42),
        Center(
          child: SizedBox(
            height: 330.h,
            child: Stack(
              children: [
                ImageCard(
                  heightFactor: 0.8,
                  rotationAngle: rotationAngle * 2,
                  x: 0.8 * 20.w,
                  y: -0.1 * 80.h,
                  color: AppColors.whiteShade200,
                ),
                ImageCard(
                  heightFactor: 0.9,
                  rotationAngle: rotationAngle,
                  x: 0.4 * 20.w,
                  y: -0.1 * 40.h,
                  color: AppColors.whiteShade100,
                ),
                AspectRatio(
                  aspectRatio: 0.85,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.whiteShade200,
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                      ),
                      Positioned(
                        top: -20,
                        left: -9,
                        child: bigCamera(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        addHeight(96),
        SizedBox(
          height: 76.r,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: List.generate(5, (_) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 76.r,
                      decoration: BoxDecoration(
                        color: AppColors.listTileColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                    Positioned(
                      top: -11,
                      left: -7,
                      child: smallCamera(),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
