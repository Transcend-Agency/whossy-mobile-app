import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class AppChip extends StatelessWidget {
  final String data;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool outlined;

  const AppChip({
    super.key,
    required this.data,
    required this.isSelected,
    this.onTap,
    this.outlined = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        decoration: BoxDecoration(
          border: outlined
              ? Border.all(
                  color: isSelected ? AppColors.black : AppColors.hintTextColor,
                  width: 1,
                )
              : null,
          borderRadius: BorderRadius.circular(6.r),
          color: isSelected ? AppColors.black : Colors.white,
        ),
        padding: outlined
            ? EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w)
            : EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              data,
              style: outlined
                  ? TextStyles.hintText.copyWith(
                      fontSize: AppUtils.scale(10.sp),
                      color:
                          isSelected ? Colors.white : AppColors.hintTextColor,
                    )
                  : TextStyles.prefText,
            ),
          ],
        ),
      ),
    );
  }
}
