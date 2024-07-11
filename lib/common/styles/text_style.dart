import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/index.dart';

class TextStyles {
  static TextStyle header = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: 'NeueMontreal',
    fontSize: 44.sp,
    wordSpacing: 4,
    letterSpacing: -1,
  );

  static TextStyle title = TextStyle(
      fontWeight: FontWeight.w600,
      fontFamily: 'NeueMontreal',
      color: AppColors.black,
      fontSize: 26.sp,
      height: 1.2);

  static TextStyle buttonText = const TextStyle(
    fontSize: 15,
    fontFamily: 'NeueMontreal',
    fontWeight: FontWeight.w500,
  );

  static TextStyle miniText = const TextStyle(
    fontSize: 17,
    color: AppColors.black,
    fontFamily: 'NeueMontreal',
  );

  static TextStyle hintThemeText = const TextStyle(
    color: AppColors.hintTextColor,
    fontSize: 15.75,
    fontFamily: 'NeueMontreal',
    height: 1.4,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  );

  static TextStyle hintText = hintThemeText.copyWith(
    fontSize: 13.sp,
  );

  static TextStyle errorStyle = TextStyle(
    color: AppColors.errorBorderColor.withOpacity(0.7),
    fontSize: 13,
    fontFamily: 'NeueMontreal',
    height: 1.4,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  );

  static TextStyle fieldHeader = const TextStyle(
    fontSize: 16,
    fontFamily: 'NeueMontreal',
    color: AppColors.black,
  );

  static TextStyle underlineText = const TextStyle(
    color: AppColors.black,
    fontFamily: 'NeueMontreal',
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
    fontSize: 16,
  );
}
