import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class ProfileViewStack extends StatelessWidget {
  final String imageUrl;
  final int likesCount;
  final String labelText;

  const ProfileViewStack({
    super.key,
    required this.imageUrl,
    required this.likesCount,
    required this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (_, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          placeholder: (_, __) => const ShimmerWidget.rectangular(),
          errorWidget: (context, url, error) {
            log('Error loading image: ${error.toString()}');

            return offline(size: 24);
          },
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              gradient: AppColors.splashGradient,
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 2.r),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  likesCount.toString(),
                  style: TextStyles.hintThemeText.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                addWidth(4),
                SvgPicture.asset(
                  AppAssets.love,
                  width: 18,
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
            child: GradientChip(text: labelText),
          ),
        ),
      ],
    );
  }
}
