import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/index.dart';

class AppSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final RangeValues range;

  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.range = const RangeValues(0, 100),
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Slider(
            value: value,
            onChanged: onChanged,
            min: range.start,
            max: range.end,
          )
        : CupertinoSlider(
            value: value,
            onChanged: onChanged,
            min: range.start,
            max: range.end,
            activeColor: AppColors.ringColor,
          );
  }
}
