import 'package:flutter/material.dart';

import '../../../constants/colors.dart';

class AppTheme {
  ThemeData appTheme() {
    return ThemeData(
      visualDensity: VisualDensity.compact,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        circularTrackColor: AppColors.buttonColor,
        color: Colors.white,
      ),
    );
  }
}
