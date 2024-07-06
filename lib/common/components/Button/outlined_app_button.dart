import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/app_utils.dart';

import '../../styles/text_style.dart';
import '../Loader/app_loader.dart';

class OutlinedAppButton extends StatelessWidget {
  final VoidCallback? onPress;
  final Color? borderColor;
  final double height;
  final bool loading;
  final String text;
  final Color textColor;
  final Widget? child;

  const OutlinedAppButton({
    super.key,
    required this.onPress,
    this.borderColor,
    this.height = 46,
    this.loading = false,
    required this.text,
    this.textColor = Colors.black,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPress,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(double.infinity, height.h),
        side: BorderSide(color: borderColor ?? Colors.black),
        shape: circularBorder,
      ),
      child: loading
          ? const AppLoader()
          : child ??
              Text(
                text,
                style: TextStyles.buttonText.copyWith(color: textColor),
                textScaler: AppUtils.scaleText(context),
              ),
    );
  }
}
