import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';

class PageIndicator extends StatelessWidget {
  const PageIndicator({
    super.key,
    required this.activePage,
    required this.pageNo,
    this.height = 5,
    this.activeColor,
    this.inActiveColor,
  });

  final int activePage;
  final int pageNo;
  final double height;
  final Color? activeColor;
  final Color? inActiveColor;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Row(
        children: List.generate(pageNo, (_) {
          return Expanded(
            child: Container(
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: _ <= activePage
                    ? activeColor ?? AppColors.primaryColor
                    : inActiveColor ?? AppColors.outlinedColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          );
        }),
      ),
    );
  }
}
