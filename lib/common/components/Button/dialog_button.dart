import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/component_style.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class DialogButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final VoidCallback? onPressed;
  final double? padding;

  const DialogButton({
    super.key,
    required this.text,
    required this.color,
    required this.textColor,
    required this.onPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      highlightElevation: 0,
      textColor: textColor,
      elevation: 0,
      shape: circularBorder, // Assuming this is a globally defined shape
      onPressed: onPressed,
      disabledColor: color.withOpacity(0.8),
      padding: EdgeInsets.symmetric(vertical: padding ?? 10.h),
      child: Text(
        text,
        style: TextStyles.buttonText.copyWith(
          fontSize: AppUtils.scale(18),
        ),
      ),
    );
  }
}
