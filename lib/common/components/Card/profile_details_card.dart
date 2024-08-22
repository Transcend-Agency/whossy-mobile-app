import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class ProfileDetailsCard extends StatelessWidget {
  const ProfileDetailsCard({
    super.key,
    required this.title,
    required this.titleImage,
    this.content,
    this.contentSpacing,
  });

  final String title;
  final String titleImage;
  final Widget? content;
  final double? contentSpacing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.listTileColor,
        borderRadius: BorderRadius.circular(10.r),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8.h,
        horizontal: 12.w,
      ),
      margin: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              color: Colors.white,
            ),
            padding: EdgeInsets.symmetric(
              vertical: 5.h,
              horizontal: 8.w,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                addWidth(2),
                SvgPicture.asset(
                  titleImage,
                  height: 18,
                ),
                addWidth(7),
                Text(
                  title,
                  style: TextStyles.prefText.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          addHeight(contentSpacing ?? 6),
          content ?? const SizedBox.shrink(),
        ],
      ),
    );
  }
}
