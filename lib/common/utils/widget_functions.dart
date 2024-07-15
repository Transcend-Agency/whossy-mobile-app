import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';
import '../styles/text_style.dart';

SizedBox addHeight(double height) => SizedBox(height: height.h);

SizedBox addWidth(double width) => SizedBox(width: width.w);

Icon visibilityIcon(bool isVisible, Color passwordColor) {
  return Icon(
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

Icon fbIcon() {
  return Icon(
    Icons.facebook,
    color: AppColors.faceBookColor,
    size: 28.r,
  );
}

Icon cancelIcon() {
  return const Icon(
    Icons.cancel,
    color: AppColors.black,
    size: 24,
  );
}

Row passwordRequirementRow(String text) {
  return Row(
    children: [
      const Icon(
        Icons.check,
        color: AppColors.hintTextColor,
        size: 18,
      ),
      addWidth(8),
      Expanded(
        child: Text(
          text,
          style: ScreenUtil().screenWidth > 500
              ? TextStyles.hintThemeText
              : TextStyles.hintText,
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ),
    ],
  );
}
