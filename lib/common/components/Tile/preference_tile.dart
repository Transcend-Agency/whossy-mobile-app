import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../constants/index.dart';

class PreferenceTile extends StatelessWidget {
  final String? text;
  final String trailing;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final Color? iconColor;
  final bool showDivider;
  final bool showTrailingIcon;
  final List<Widget>? customChildren;

  const PreferenceTile({
    super.key,
    required this.text,
    this.onTap,
    this.textStyle,
    this.iconColor,
    this.showDivider = true,
    this.showTrailingIcon = true,
    required this.trailing,
    this.customChildren,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: customChildren != null
          ? Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [...?customChildren],
                ),
              ),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      text!,
                      style: textStyle ?? TextStyles.prefText,
                    ),
                    Container(
                      margin:
                          EdgeInsets.only(top: 13.r, bottom: 13.r, left: 12.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            trailing,
                            style: (textStyle ?? TextStyles.prefText).copyWith(
                              color: AppColors.hintTextColor,
                            ),
                          ),
                          if (onTap != null && showTrailingIcon) ...[
                            addWidth(6),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: iconColor ?? AppColors.hintTextColor,
                              size: 16,
                            ),
                          ]
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
