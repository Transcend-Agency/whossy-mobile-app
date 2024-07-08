import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/app_utils.dart';
import 'package:whossy_mobile_app/constants/colors.dart';

import '../../styles/text_style.dart';
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
    return MaterialButton(
      height: height.h,
      minWidth: double.infinity,
      onPressed: onPress,
      color: AppColors.buttonColor,
      textColor: Colors.white,
      elevation: 0,
      shape: circularBorder,
      disabledColor: Colors.grey[100],
      child: loading
          ? const AppLoader()
          : Text(
              text,
              style: TextStyles.buttonText,
              textScaler: AppUtils.scaleText(context),
            ),
    );
  }
}
