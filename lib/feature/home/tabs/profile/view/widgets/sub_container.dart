import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/text_style.dart';

import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class SubscriptionContainer extends StatelessWidget {
  final String title;
  final String feature;
  final String chipText;
  final bool isTappable;
  final VoidCallback? onTap;

  const SubscriptionContainer({
    super.key,
    required this.title,
    required this.feature,
    required this.chipText,
    this.isTappable = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: EdgeInsets.only(left: 11.r, right: 11.r, top: 6.r, bottom: 10.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outlinedColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.profileHead.copyWith(
              fontSize: AppUtils.scale(12.sp) ?? 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          addHeight(6),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Opacity(
                  opacity: 0.9,
                  child: Text(
                    feature,
                    style: TextStyles.hintThemeText.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: AppUtils.scale(10.sp) ?? 13.5.sp,
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  gradient: AppColors.splashGradient,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 9.r,
                  vertical: 3.r,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      chipText,
                      style: TextStyles.hintThemeText.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: AppUtils.scale(9.sp) ?? 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (isTappable) {
      return GestureDetector(
        onTap: onTap,
        child: content,
      );
    }

    return content;
  }
}
