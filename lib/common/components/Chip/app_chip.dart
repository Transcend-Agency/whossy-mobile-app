import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class AppChip extends StatelessWidget {
  final String data;
  final bool isSelected;
  final VoidCallback onTap;

  const AppChip({
    super.key,
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.black : AppColors.hintTextColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6.r),
          color: isSelected ? AppColors.black : Colors.white,
        ),
        padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w),
        margin: EdgeInsets.only(right: 4.w, bottom: 6.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data,
              style: TextStyles.hintText.copyWith(
                fontSize: AppUtils.scale(10.sp),
                color: isSelected ? Colors.white : AppColors.hintTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
