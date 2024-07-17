import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/constants/colors.dart';

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
    this.height = 50,
    this.loading = false,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialButton(
        height: height.h,
        onPressed: onPress,
        color: AppColors.buttonColor,
        textColor: Colors.white,
        elevation: 0,
        highlightElevation: 0,
        shape: circularBorder,
        disabledColor: AppColors.buttonColor.withOpacity(0.7),
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
