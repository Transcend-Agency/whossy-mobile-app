import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/index.dart';

class AppSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onChanged;
  final RangeValues range;
  final bool useSliderTheme;

  AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.range = const RangeValues(0, 100),
    this.useSliderTheme = false,
  }); // Default to an empty Spacing object

  final bool isAndroid = Platform.isAndroid;

  @override
  Widget build(BuildContext context) {
    return isAndroid
        ? (useSliderTheme
            ? SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 1,
                  activeTrackColor: AppColors.activeTrackColor,
                  inactiveTrackColor: Colors.white,
                  thumbColor: Colors.white,
                ),
                child: _slider(),
              )
            : _slider())
        : FractionallySizedBox(
            widthFactor: 1,
            child: CupertinoSlider(
              value: value,
              onChanged: onChanged,
              min: range.start,
              max: range.end,
              activeColor: AppColors.black,
            ),
          );
  }

  Widget _slider() {
    return Slider(
      value: value,
      onChanged: onChanged,
      min: range.start,
      max: range.end,
    );
  }
}
