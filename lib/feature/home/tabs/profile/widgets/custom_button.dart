import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle,
    required this.containerColor,
    required this.textColor,
  });

  final String imagePath;
  final String title;
  final String subTitle;
  final Color containerColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.all(12.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 40.r,
              child: Image.asset(imagePath),
            ),
            addWidth(10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyles.whossyGuideText,
                ),
                Text(
                  subTitle,
                  style: TextStyles.underlineWhossyGuide.copyWith(
                    color: textColor,
                    decorationColor: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
