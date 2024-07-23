import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class GenericTile<T> extends StatelessWidget {
  final Widget? leadingWidget;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String title;

  const GenericTile({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    this.leadingWidget,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
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
            contentPadding: EdgeInsets.only(left: 16, right: 12.w),
            leading: leadingWidget,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9.r),
            ),
            tileColor: AppColors.whiteShade200,
            trailing: Container(
              width: 16.r,
              height: 16.r,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.whiteShade200 : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? Colors.transparent : AppColors.outlinedColor,
                  width: 1.5,
                ),
              ),
            ),
            title: Text(
              title,
              style: TextStyles.hintText.copyWith(
                fontSize: AppUtils.scale(11.sp),
                color: AppColors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
