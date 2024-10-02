import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/index.dart';
import '../index.dart';

class ShimmerTile extends StatelessWidget {
  const ShimmerTile({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ListTile(
      contentPadding: EdgeInsets.only(top: 6.h),
      leading: CircleAvatar(
        radius: 30.r,
        child: const ShimmerWidget.circular(),
      ),
      horizontalTitleGap: 14.r,
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          addHeight(4),
          ShimmerWidget.rectangular(
            width: width * 0.135,
            border: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.r)),
            ),
            height: 18.h,
          ),
        ],
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4.h, bottom: 12.h),
            child: ShimmerWidget.rectangular(
              width: width * 0.3,
              height: 21.h,
              border: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6.r),
              ),
            ),
          ),
        ],
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //  addHeight(6),
          ShimmerWidget.rectangular(
            height: 14.h,
            border: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          addHeight(6),
        ],
      ),
    );
  }
}
