import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/common/styles/text_style.dart';

import '../../../constants/colors.dart';
import '../../styles/component_style.dart';

class AppTheme {
  ThemeData appTheme() {
    return ThemeData(
      outlinedButtonTheme: const OutlinedButtonThemeData(style: ButtonStyle()),
      visualDensity: VisualDensity.compact,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        circularTrackColor: AppColors.buttonColor,
        color: Colors.white,
      ),
      colorScheme: const ColorScheme.light(
        background: Colors.white,
      ),

      // Configure the input decoration theme for form fields.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        hintStyle: TextStyles.hintText,
        errorStyle: TextStyles.errorStyle,
        enabledBorder: enabledBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,
      ),
    );
  }
}
