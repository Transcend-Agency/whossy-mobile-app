import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

part 'single_select_app_chip.dart';

class AppChip extends StatelessWidget {
  final String data;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool outlined;
  final EdgeInsetsGeometry? padding;
  final bool isBold;

  const AppChip({
    super.key,
    required this.data,
    required this.isSelected,
    this.onTap,
    this.outlined = true,
    this.padding,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
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
        padding: padding ??
            (outlined
                ? EdgeInsets.symmetric(vertical: 3.h, horizontal: 5.w)
                : EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w)),
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
                  : TextStyles.prefText.copyWith(
                      fontWeight: isBold ? FontWeight.w500 : null,
                      fontSize: isBold
                          ? AppUtils.scale(9.5.sp) ?? 12.sp
                          : AppUtils.scale(11.5.sp) ?? 13.sp,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
