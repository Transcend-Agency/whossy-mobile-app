import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    this.color,
    this.child,
    this.bottomOnly = false,
  });

  final Color? color;
  final Widget? child;
  final bool bottomOnly;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      height: ScreenUtil().screenHeight * 0.8,
      decoration: BoxDecoration(
        borderRadius: bottomOnly
            ? BorderRadius.vertical(bottom: Radius.circular(14.r))
            : BorderRadius.all(Radius.circular(14.r)),
        color: color ?? const Color(0xFFF2F2F2),
      ),
      child: child,
    );
  }
}
