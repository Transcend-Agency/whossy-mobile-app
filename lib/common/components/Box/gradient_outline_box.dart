import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';

class GradientOutlineBox extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;

  const GradientOutlineBox({super.key, required this.child, this.gradient});

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
          width: 138,
          height: 150,
        ),
        child,
      ],
    );
  }
}
