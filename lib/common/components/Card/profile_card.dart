import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/utils/utils.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    super.key,
    this.color,
    this.child,
    this.bottomOnly = false,
    this.addedHeight = 0,
    this.heightFactor = 0.8,
  });

  final Color? color;
  final Widget? child;
  final double heightFactor;
  final bool bottomOnly;
  final double addedHeight;

  @override
  Widget build(BuildContext context) {
    final container = Container(
      clipBehavior: Clip.antiAlias,
      height: ScreenUtil().screenHeight * heightFactor,
      decoration: BoxDecoration(
        borderRadius: bottomOnly
            ? BorderRadius.vertical(bottom: Radius.circular(14.r))
            : BorderRadius.all(Radius.circular(14.r)),
        color: color ?? const Color(0xFFF2F2F2),
      ),
      child: child,
    );

    if (addedHeight == 0) {
      return container;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        container,
        addHeight(addedHeight),
      ],
    );
  }
}
