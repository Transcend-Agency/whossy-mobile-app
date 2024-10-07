import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconly/iconly.dart';

import '../../constants/colors.dart';
import '../styles/text_style.dart';
import 'index.dart';

SizedBox addHeight(double height, {bool isRsv = true}) =>
    SizedBox(height: isRsv ? height.h : height);

SizedBox addWidth(double width, {bool isRsv = true}) =>
    SizedBox(width: isRsv ? width.w : width);

Widget svgIcon(String path, {double? size, Color? color}) {
  return SvgPicture.asset(
    path,
    width: size ?? 22.r,
    colorFilter: ColorFilter.mode(
      color ?? Colors.transparent,
      BlendMode.srcIn,
    ),
  );
}

Icon alert() {
  return const Icon(
    Icons.warning_rounded,
    color: AppColors.sbErrorBorderColor,
    size: 24,
  );
}

Widget sendIcon() {
  return Icon(
    IconlyBold.send,
    size: 23.r,
    color: Colors.black,
  );
}

Widget moreIcon() {
  return Icon(
    Icons.more_horiz_rounded,
    size: 23.r,
    color: Colors.black,
  );
}

Widget voiceIcon() {
  return Icon(
    IconlyBold.voice,
    size: 24.r,
    color: Colors.black,
  );
}

Icon offline({double size = 32}) {
  return Icon(
    Icons.cloud_off_rounded,
    size: size.r,
    color: AppColors.outlinedColor,
  );
}

Icon user({double size = 32}) {
  return Icon(
    IconlyLight.profile,
    size: size.r,
    color: AppColors.outlinedColor,
  );
}

Icon visibilityIcon(bool isVisible, Color passwordColor) {
  return Icon(
    isVisible ? Icons.visibility_off : Icons.visibility,
    color: passwordColor,
    size: 20,
  );
}

Icon dropDownIcon({double size = 20}) {
  return Icon(
    IconlyLight.arrow_down_2,
    size: size.r,
    color: AppColors.hintTextColor,
  );
}

Icon fbIcon() {
  return Icon(
    Icons.facebook,
    color: AppColors.faceBookColor,
    size: 28.r,
  );
}

Icon phone() {
  return Icon(
    Icons.phone,
    color: AppColors.black,
    size: 22.r,
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
    size: 23,
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

Icon checkIcon() {
  return Icon(
    Icons.check,
    color: Colors.black,
    size: 21.r,
  );
}

Widget greenDot() {
  return Container(
    width: 8,
    height: 8,
    decoration: const BoxDecoration(
      color: Colors.green,
      shape: BoxShape.circle,
    ),
  );
}

Widget contentText(String data) {
  return Text(
    data,
    style: TextStyles.bioText.copyWith(
      fontSize: AppUtils.scale(11.5.sp),
    ),
    textAlign: TextAlign.center,
  );
}

Row passwordRequirementRow(String text, {required bool checked}) {
  TextStyle textStyle = ScreenUtil().screenWidth > 500
      ? TextStyles.hintThemeText
      : TextStyles.hintText;

  return Row(
    children: [
      Icon(
        Icons.check,
        color: checked ? Colors.green.shade300 : AppColors.hintTextColor,
        size: 18,
      ),
      addWidth(8),
      Expanded(
        child: Text(
          text,
          style:
              textStyle.copyWith(color: checked ? Colors.green.shade300 : null),
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
