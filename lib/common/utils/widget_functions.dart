import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget addHeight(double height) => SizedBox(height: height.h);

Widget addWidth(double width) => SizedBox(width: width.w);

Icon visibilityIcon(bool isVisible, Color passwordColor) {
  return Icon(
    // Based on passwordVisible state choose the icon
    isVisible ? Icons.visibility_off : Icons.visibility,
    color: passwordColor,
    size: 20,
  );
}
