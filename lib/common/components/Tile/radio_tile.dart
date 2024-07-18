import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class RadioTile<T> extends StatelessWidget {
  final String leadingAsset;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String title;
  final String subtitle;

  const RadioTile({
    super.key,
    required this.leadingAsset,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 1),
            leading: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Image.asset(leadingAsset, height: 56.r),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.r),
            ),
            tileColor: AppColors.listTileColor,
            trailing: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Container(
                width: 16.r,
                height: 16.r,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.listTileColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? Colors.transparent
                        : AppColors.outlinedColor,
                    width: 1.5,
                  ),
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyles.hintText.copyWith(
                fontSize: AppUtils.scale(12.sp),
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 2.h),
              child: Text(
                subtitle,
                style: TextStyles.hintText.copyWith(
                  fontSize: AppUtils.scale(10.sp),
                  color: AppColors.black,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
