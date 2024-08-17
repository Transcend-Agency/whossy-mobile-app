import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/index.dart';
import '../utils/index.dart';

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
    height: 1.2,
  );

  static TextStyle welcome = TextStyle(
    fontWeight: FontWeight.w600,
    fontFamily: 'NeueMontreal',
    fontSize: 26.sp,
    height: 1.2,
  );

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

  static TextStyle profileHead = const TextStyle(
    fontFamily: 'NeueMontreal',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.1,
  );

  static TextStyle text = hintThemeText.copyWith(
    fontSize: 13.sp,
    color: AppColors.black,
  );

  static TextStyle prefText = text.copyWith(
    fontSize: AppUtils.scale(11.5.sp),
  );

  static TextStyle boldPrefText = text.copyWith(
    fontSize: AppUtils.scale(13.5.sp) ?? 15.sp,
    fontWeight: FontWeight.w500,
  );

  static TextStyle whossyGuideText = TextStyle(
    fontSize: AppUtils.scale(12.5.sp) ?? 14.sp,
    fontWeight: FontWeight.w500,
    fontFamily: 'NeueMontreal',
    letterSpacing: -0.1,
  );

  static TextStyle underlineWhossyGuide = whossyGuideText.copyWith(
    decoration: TextDecoration.underline,
    fontWeight: FontWeight.w400,
    fontSize: AppUtils.scale(11.5.sp) ?? 13.sp,
  );

  static TextStyle bioText = hintThemeText.copyWith(
    fontSize: 13.sp,
  );

  static TextStyle snackBarText = bioText.copyWith(
    fontSize: AppUtils.scale(10.5.sp),
    color: AppColors.sbErrorBorderColor,
    decoration: TextDecoration.none,
  );

  static TextStyle underlineText = hintThemeText.copyWith(
    fontSize: 16.sp,
    letterSpacing: 1.2,
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
    fontSize: 15,
    fontFamily: 'NeueMontreal',
    color: AppColors.black,
  );

  static TextStyle tickTitle = TextStyle(
    fontSize: 14.sp,
    color: AppColors.black,
    fontWeight: FontWeight.w500,
  );

  static TextStyle privacyText = const TextStyle(
    color: AppColors.black,
    fontFamily: 'NeueMontreal',
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
    fontSize: 15,
  );

  static TextStyle iconText = TextStyle(
    fontSize: 27.sp,
  );
}
