import 'dart:io' show Platform;

import 'package:flutter/material.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({
    super.key,
    this.size = 20,
    this.color = Colors.white,
    this.value,
  });
  final double size;
  final Color color;
  final double? value;

  @override
  Widget build(BuildContext context) {
    // Wrap the loader with ProgressIndicatorTheme
    return ProgressIndicatorTheme(
      data: ProgressIndicatorTheme.of(context).copyWith(
        color: color,
      ),
      child: Center(
        child: SizedBox.square(
          dimension: size,
          child: CircularProgressIndicator.adaptive(
            backgroundColor: Platform.isIOS ? color : Colors.transparent,
            strokeWidth: 2.5,
            value: value,
          ),
        ),
      ),
    );
  }
}
