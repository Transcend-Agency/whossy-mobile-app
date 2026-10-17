import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/utils/utils.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';

class GenderChip<T> extends StatelessWidget {
  final Widget? leadingWidget;
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String title;

  const GenderChip({
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
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          color: isSelected ? AppColors.black : Colors.white,
        ),
        padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 6.w),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            leadingWidget ?? const SizedBox.shrink(),
            addWidth(4),
            Text(
              title,
              style: TextStyles.prefText.copyWith(
                color: isSelected ? Colors.white : null,
                fontSize: AppUtils.scale(10.sp) ?? 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
