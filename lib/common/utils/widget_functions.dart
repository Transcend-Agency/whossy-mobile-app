import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';

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

Icon backIcon() {
  return const Icon(
    Icons.arrow_back_ios_new_rounded,
  );
}

Icon cancelIcon() {
  return const Icon(
    Icons.cancel,
    color: AppColors.black,
    size: 24,
  );
}

Icon camera({double size = 42, Color color = AppColors.midWay}) {
  return Icon(
    IconlyBold.camera,
    size: size.r,
    color: color,
  );
}

Icon add({Color color = AppColors.midWay, double size = 26}) {
  return Icon(
    Icons.add_circle_rounded,
    size: size.r,
    color: color,
  );
}

Icon search() {
  return Icon(
    IconlyLight.search,
    color: AppColors.hintTextColor,
    size: 18.r,
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

Widget bigCamera() {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      camera(size: 46, color: Colors.white),
      camera(),
      Positioned(
        right: -3.5,
        bottom: -3.5,
        child: Container(
          height: 29.r,
          width: 29.r,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
        right: -1.5,
        bottom: -1.5,
        child: add(),
      ),
    ],
  );
}

Widget smallCamera({Color color = AppColors.hintTextColor}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      camera(size: 29, color: Colors.white),
      camera(color: color, size: 25),
      Positioned(
        right: -3.5,
        bottom: -3.5,
        child: Container(
          height: 19.r,
          width: 19.r,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
      Positioned(
        right: -2,
        bottom: -2,
        child: add(color: color, size: 16.5),
      ),
    ],
  );
}
