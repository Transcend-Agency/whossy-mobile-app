import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/components/components.dart';

class ProfileView extends StatelessWidget {
  const ProfileView(
      {super.key, required this.child, required this.size, this.gradient});

  final Widget child;
  final Size size;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GradientOutlineBox(
        gradient: gradient,
        size: size,
        child: Container(
          height: size.height,
          width: size.width,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white, width: 3.r),
          ),
          child: Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
