import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class WhossySafetyGuide extends StatelessWidget {
  const WhossySafetyGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Nav.push(context, const SafetyGuide()),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: AppColors.inputBackGround,
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppAssets.guide,
              width: 20.r,
            ),
            addWidth(8),
            Text(
              'Whossy Safety Guide',
              style: TextStyles.whossyGuideText,
            ),
          ],
        ),
      ),
    );
  }
}
