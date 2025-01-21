import 'dart:io' show Platform;

import 'package:cupertino_range_slider_improved/cupertino_range_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants/index.dart';

class AppRangeSlider extends StatelessWidget {
  AppRangeSlider({
    super.key,
    required this.values,
    required this.onChanged,
    required this.range,
  });

  final RangeValues values;
  final RangeValues range;
  final ValueChanged<RangeValues> onChanged;

  final bool isAndroid = Platform.isAndroid;

  @override
  Widget build(BuildContext context) {
    return isAndroid
        ? SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.activeTrackColor,
              inactiveTrackColor: Colors.white,
              thumbColor: Colors.white,
            ),
            child: RangeSlider(
              values: values,
              onChanged: onChanged,
              min: range.start,
              max: range.end,
            ),
          )
        : FractionallySizedBox(
            widthFactor: 1,
            child: CupertinoRangeSlider(
              activeColor: AppColors.black,
              minValue: values.start,
              maxValue: values.end,
              min: range.start,
              max: range.end,
              onMinChanged: (start) =>
                  onChanged(RangeValues(start, values.end)),
              onMaxChanged: (end) => onChanged(RangeValues(values.start, end)),
              trackColor: CupertinoColors.systemGrey4,
            ),
          );
  }
}
