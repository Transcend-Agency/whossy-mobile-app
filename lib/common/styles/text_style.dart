import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextStyles {
  static TextStyle header = TextStyle(
    fontWeight: FontWeight.w700,
    fontFamily: 'NeueMontreal',
    fontSize: 44.sp,
    wordSpacing: 4,
    letterSpacing: -1,
  );

  static TextStyle buttonText = const TextStyle(
    fontSize: 19,
    fontFamily: 'NeueMontreal',
  );

  static TextStyle miniText = const TextStyle(
    color: Colors.black,
    fontSize: 17,
    fontFamily: 'NeueMontreal',
  );
}
