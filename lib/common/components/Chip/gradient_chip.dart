import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class GradientChip extends StatelessWidget {
  const GradientChip({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.skewX(-.3),
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          gradient: AppColors.splashGradient,
        ),
        child: Transform(
          transform: Matrix4.skewX(0.3),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyles.hintThemeText.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: AppUtils.scale(10.sp) ?? 12.5.sp,
            ),
          ),
        ),
      ),
    );
  }
}
