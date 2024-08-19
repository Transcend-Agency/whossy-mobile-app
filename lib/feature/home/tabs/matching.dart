import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';

class Matching extends StatelessWidget {
  const Matching({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding,
      child: SizedBox(
        width: 375.w,
        child: Column(
          children: [
            addHeight(8),
            const HeaderBar(icon: Icons.notifications_rounded),
            addHeight(36),
            Text(
              'One',
              style: TextStyles.title.copyWith(fontSize: 24.sp),
            ),
          ],
        ),
      ),
    );
  }
}