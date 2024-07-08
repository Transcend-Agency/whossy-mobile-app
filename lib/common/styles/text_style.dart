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
  );

  static TextStyle buttonText = const TextStyle(
    fontSize: 16,
    fontFamily: 'NeueMontreal',
  );

  static TextStyle miniText = const TextStyle(
    fontSize: 17,
    color: AppColors.black,
    fontFamily: 'NeueMontreal',
  );

  static TextStyle hintText = const TextStyle(
    color: AppColors.hintTextColor,
    fontSize: 15.5,
    fontFamily: 'NeueMontreal',
    height: 1.4,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  );

  static TextStyle errorStyle = TextStyle(
    color: AppColors.errorBorderColor.withOpacity(0.7),
    fontSize: 13,
    fontFamily: 'NeueMontreal',
    height: 1.4,
    letterSpacing: 0.4,
    fontWeight: FontWeight.w400,
  );

  static TextStyle fieldHeader = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'NeueMontreal',
  );

  static TextStyle underlineText = TextStyle(
    color: AppColors.black,
    fontFamily: 'NeueMontreal',
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
    fontSize: 14.sp,
  );
}
