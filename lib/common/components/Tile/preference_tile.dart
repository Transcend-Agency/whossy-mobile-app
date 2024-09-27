import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../constants/index.dart';
import '../index.dart';

class PreferenceTile extends StatelessWidget {
  final String? text;
  final String? trailing;
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
    this.trailing,
    this.customChildren,
  });

  @override
  Widget build(BuildContext context) {
    // Check if trailing is null once
    final hasTrailing = trailing != null;

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
                      margin: EdgeInsets.only(
                        top: hasTrailing ? 13.r : 16.r,
                        bottom: hasTrailing ? 13.r : 16.r,
                        left: 12.h,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppAnimatedSwitcher(
                            child: hasTrailing
                                ? Text(
                                    trailing!,
                                    style: (textStyle ?? TextStyles.prefText)
                                        .copyWith(
                                      color: AppColors.hintTextColor,
                                    ),
                                    textAlign: TextAlign.right,
                                    key: const ValueKey('data'),
                                  )
                                : ShimmerWidget.rectangular(
                                    height: 15.h,
                                    width: ScreenUtil().screenWidth * 0.35,
                                    border: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                    key: const ValueKey<bool>(false),
                                  ),
                          ),
                          if (onTap != null && showTrailingIcon) ...[
                            addWidth(6),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: iconColor ?? AppColors.hintTextColor,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                    )
                  ],
                ),
                if (showDivider) const AppDivider(),
              ],
            ),
    );
  }
}
