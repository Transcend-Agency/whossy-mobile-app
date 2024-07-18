import 'package:flutter/material.dart';

class AppColors {
  static const Color warmYellow = Color(0xffff5804);
  static const Color midWay = Color(0xfff6352a);
  static const Color primaryColor = Color(0xffF0174B);
  static const Color black = Color(0xff121212);

  static const Color buttonColor = Color(0xfff2243e);

  static const Color inputBackGround = Color(0xFFF5F5F5);
  static const Color selectedFieldColor = Color(0xFFD9D9D9);

  static const Color hintTextColor = Color(0xFF8a8a8e);
  static const Color outlinedColor = Color(0xFFD9D9D9);
  static const Color optionsSheetDivider = Color(0xFFECECEC);
  static const Color errorBorderColor = AppColors.primaryColor;
  // Color(0xFFFF0A0A);

  static const Color faceBookColor = Color(0xFF1877f2);
  static const Color backButtonColor = Color(0xFFF8F8F8);
  static const Color listTileColor = Color(0xFFF6F6F6);

  static const splashGradient = LinearGradient(
    colors: [AppColors.warmYellow, AppColors.primaryColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const splashVariation = LinearGradient(
    colors: [AppColors.warmYellow, AppColors.primaryColor],
    stops: [0.3, 0.6],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const pageIndicatorColor = LinearGradient(
    colors: [AppColors.warmYellow, AppColors.primaryColor],
    stops: [0.3, 0.6],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static LinearGradient splashShade = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Colors.white.withOpacity(0),
      Colors.white,
    ],
    stops: const [0.0, 0.225],
  );
}
