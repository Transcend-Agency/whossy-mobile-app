import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconBox extends StatelessWidget {
  final String iconPath;
  final double size;

  const IconBox({
    super.key,
    required this.iconPath,
    this.size = 37.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size.sp,
      child: Image.asset(iconPath),
    );
  }
}
