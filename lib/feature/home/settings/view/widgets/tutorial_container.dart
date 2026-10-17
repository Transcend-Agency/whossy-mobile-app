import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';

class TutorialComponent extends HookWidget {
  const TutorialComponent({
    super.key,
    required this.title,
    required this.body,
    this.next = 'Next',
    this.skip = 'Skip',
    this.step,
    this.onSkip,
    this.onNext,
  });

  final String title;
  final String body;
  final String next;
  final String? step;
  final String skip;
  final VoidCallback? onSkip;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyles.boldPrefText.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: AppUtils.scale(14.sp) ?? 16.sp,
                ),
              ),

              if(step != null)
              Text(
                step!,
                style: TextStyles.prefText.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          addHeight(12),
          Text(
            body,
            style: TextStyles.prefText.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          addHeight(6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onSkip != null) ...[
                TextButton(
                  onPressed: onSkip,
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    skip,
                    style: TextStyles.prefText.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                addWidth(6),
              ],
              if (onNext != null)
                ElevatedButton(
                  onPressed: onNext,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    backgroundColor: AppColors.buttonColor,
                    elevation: 0, // Remove elevation
                  ),
                  child: Text(
                    next,
                    style: TextStyles.prefText.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ), // Adjust text color if needed
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}
