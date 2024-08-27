import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/constants/colors.dart';

import '../../styles/text_style.dart';
import '../../utils/app_utils.dart';
import '../Loader/app_loader.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPress;
  final Color? color;
  final double height;
  final bool loading;
  final String text;

  const AppButton({
    super.key,
    required this.onPress,
    this.color,
    this.height = 46,
    this.loading = false,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: MaterialButton(
        height: height.h,
        color: color ?? AppColors.buttonColor,
        onPressed: loading || onPress == null ? null : onPress,
        textColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        shape: circularBorder,
        disabledColor: AppColors.buttonColor.withOpacity(0.8),
        child: loading
            ? const AppLoader()
            : Text(
                text,
                style: TextStyles.buttonText.copyWith(
                  fontSize: AppUtils.scale(18),
                ),
              ),
      ),
    );
  }
}
