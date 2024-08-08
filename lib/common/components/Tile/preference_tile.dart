import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../constants/index.dart';

class PreferenceTile extends StatelessWidget {
  final String text;
  final String? trailing;
  final VoidCallback onTap;
  final TextStyle? textStyle;
  final Color? iconColor;
  final bool showDivider;

  const PreferenceTile({
    super.key,
    required this.text,
    required this.onTap,
    this.textStyle,
    this.iconColor,
    this.showDivider = true,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: textStyle ?? TextStyles.prefText,
              ),
              Container(
                margin: EdgeInsets.only(top: 13.h, bottom: 13.h, left: 12.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      trailing ?? 'Choose',
                      style: (textStyle ?? TextStyles.prefText).copyWith(
                        color: AppColors.hintTextColor,
                      ),
                    ),
                    addWidth(6),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: iconColor ?? AppColors.hintTextColor,
                      size: 16,
                    ),
                  ],
                ),
              )
            ],
          ),
          if (showDivider)
            const Divider(
              color: AppColors.outlinedColor,
              height: 0,
            ),
        ],
      ),
    );
  }
}
