import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'shimmer_widget.dart';

class ShimmerSwitch extends StatelessWidget {
  const ShimmerSwitch({super.key, this.height = 21, this.width = 37});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return ShimmerWidget.rectangular(
      height: height.h,
      width: width.w,
      border: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      key: const ValueKey(false),
    );
  }
}
