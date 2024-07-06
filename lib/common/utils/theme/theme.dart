import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

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
    );
  }
}
