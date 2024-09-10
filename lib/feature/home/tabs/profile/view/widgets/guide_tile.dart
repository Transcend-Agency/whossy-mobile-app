import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class GuideTile extends StatelessWidget {
  final VoidCallback onPressed;
  final String imageAssetPath;
  final String mainText;

  const GuideTile({
    super.key,
    required this.onPressed,
    required this.imageAssetPath,
    required this.mainText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: MaterialButton(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        height: 50.h,
        color: AppColors.listTileColor,
        onPressed: onPressed,
        elevation: 0,
        highlightElevation: 0,
        shape: circularBorder,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(imageAssetPath, height: 38.r),
                addWidth(8),
                Text(
                  mainText,
                  style: TextStyles.boldPrefText,
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
