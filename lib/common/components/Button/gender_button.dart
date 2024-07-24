import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class GenderButton extends StatelessWidget {
  final String label;
  final Gender? value;
  final Gender? groupValue;
  final ValueChanged<Gender?> onChanged;

  const GenderButton({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: isSelected ? AppColors.black : AppColors.inputBackGround,
          ),
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        value.icon,
                        size: 24.r,
                        color:
                            isSelected ? Colors.white : AppColors.hintTextColor,
                      ),
                      addWidth(2),
                      Text(
                        label,
                        style: TextStyles.hintText.copyWith(
                          fontSize: AppUtils.scale(11.5.sp),
                          color: isSelected ? Colors.white : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
