import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../constants/colors.dart';
import '../../styles/text_style.dart';
import '../../utils/app_utils.dart';
import '../Loader/app_loader.dart';

class OutlinedAppButton extends StatelessWidget {
  final VoidCallback? onPress;
  final Color? borderColor;
  final double height;
  final double width;
  final bool loading;
  final String? text;
  final Color textColor;
  final Widget? child;

  const OutlinedAppButton({
    super.key,
    required this.onPress,
    this.borderColor,
    this.height = 46,
    this.loading = false,
    this.text,
    this.textColor = AppColors.hintTextColor,
    this.child,
    this.width = 94,
  }) : assert(text != null || child != null,
            'Either text or child must be provided.');

  @override
  Widget build(BuildContext context) {
    double? fontSize = AppUtils.scale(17);

    return OutlinedButton(
      onPressed: onPress,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryColor,
        minimumSize: Size(width.w, height.h),
        side: BorderSide(color: borderColor ?? AppColors.outlinedColor),
        shape: circularBorder,
      ),
      child: loading
          ? const AppLoader()
          : DefaultTextStyle(
              style: TextStyles.buttonText.copyWith(
                color: textColor,
                fontSize: fontSize,
              ),
              child: child ??
                  Text(
                    text!,
                    style: TextStyles.buttonText.copyWith(
                      color: textColor,
                      fontSize: fontSize,
                    ),
                  ),
            ),
    );
  }
}
