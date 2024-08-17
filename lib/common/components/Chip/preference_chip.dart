import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class PreferenceChip<T> extends StatelessWidget {
  final Widget? leadingWidget;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String title;

  const PreferenceChip({
    super.key,
    this.leadingWidget,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: isSelected ? AppColors.black : AppColors.listTileColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 6.r, horizontal: 8.r),
        child: Text(
          title,
          style: TextStyles.hintText.copyWith(
            fontSize: AppUtils.scale(10.sp),
            color: isSelected ? Colors.white : AppColors.hintTextColor,
          ),
        ),
      ),
    );
  }
}
