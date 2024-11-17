import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/component_style.dart';
import '../index.dart';

class ShimmerBlockedTile extends StatelessWidget {
  const ShimmerBlockedTile({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return ListTile(
      contentPadding: pagePadding.copyWith(top: 7.r, bottom: 4.r),
      leading: const CircleAvatar(
        radius: 25,
        child: ShimmerWidget.circular(),
      ),
      horizontalTitleGap: 14,
      trailing: ShimmerWidget.rectangular(
        width: width * 0.11,
        border: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
        ),
        height: 22.5,
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ShimmerWidget.rectangular(
            width: width * 0.25,
            height: 20,
            border: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ],
      ),
    );
  }
}
