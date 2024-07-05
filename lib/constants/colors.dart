import 'package:flutter/material.dart';

class AppColors {
  static const Color warmYellow = Color(0xffff5804);
  static const Color midWay = Color(0xfff6352a);
  static const Color primaryColor = Color(0xffF0174B);

  static const Color buttonColor = Color(0xfff2243e);

  static const splashGradient = LinearGradient(
    colors: [AppColors.warmYellow, AppColors.primaryColor],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
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
