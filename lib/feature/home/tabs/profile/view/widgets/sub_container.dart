import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/text_style.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class SubscriptionContainer extends StatelessWidget {
  final String title;
  final String feature;
  final String chipText;

  const SubscriptionContainer({
    super.key,
    required this.title,
    required this.feature,
    required this.chipText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            ),
          ),
          addHeight(6),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  feature,
                  style: TextStyles.hintThemeText.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: AppUtils.scale(10.sp) ?? 13.5.sp,
                  ),
                ),
              ),
              GradientChip(
                text: chipText,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
