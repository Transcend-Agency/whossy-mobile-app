import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class SkipButton extends StatelessWidget {
  final int page;
  final VoidCallback onTap;

  const SkipButton({super.key, required this.page, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return [4, 5, 6, 7, 8, 9].contains(page)
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: onTap,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: AppColors.listTileColor,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
                  margin: EdgeInsets.only(top: 4.h, bottom: 6.h),
                  child: Text(
                    'Skip',
                    style: TextStyles.hintText.copyWith(
                      fontSize: AppUtils.scale(10.5.sp),
                      color: AppColors.black,
                    ),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox.shrink();
  }
}
