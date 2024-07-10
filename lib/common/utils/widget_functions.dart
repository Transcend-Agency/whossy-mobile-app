import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

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

Icon searchIcon() {
  return Icon(
    Icons.search,
    color: AppColors.hintTextColor,
    size: 18.r,
  );
}
