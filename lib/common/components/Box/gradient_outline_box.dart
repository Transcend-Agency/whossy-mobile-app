import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';

class GradientOutlineBox extends StatelessWidget {
  final Widget child;
  final Size size;
  final Gradient? gradient;

  const GradientOutlineBox({
    super.key,
    required this.child,
    this.gradient,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: gradient ?? AppColors.splashGradient,
            borderRadius: BorderRadius.circular(18.r),
          ),
          width: size.width + 6,
          height: size.height + 6,
        ),
        child,
      ],
    );
  }
}
