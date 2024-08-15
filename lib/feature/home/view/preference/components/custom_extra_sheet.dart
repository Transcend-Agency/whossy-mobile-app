import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';

class CustomExtraSheet<T> extends StatefulWidget {
  const CustomExtraSheet({super.key});

  @override
  State<CustomExtraSheet<T>> createState() => _CustomExtraSheetState<T>();
}

class _CustomExtraSheetState<T> extends State<CustomExtraSheet<T>> {
  // Set initial height range values
  RangeValues currentRangeValues = const RangeValues(160, 200);
  late T? data;
  bool hasChanged = false;

  // Example groupValue and onChanged function
  void onChanged(T? value) {
    setState(() {
      hasChanged = data != value;
      if (hasChanged) data = value;
    });
  }

  void updateRange(RangeValues values) {
    setState(() => currentRangeValues = values);
  }

  // Helper function to convert cm to feet and inches
  String convertCmToInches(double cm) {
    final totalInches = cm / 2.54;
    final feet = totalInches ~/ 12;
    final inches = totalInches % 12;
    return "$feet'${inches.toStringAsFixed(0)}\"";
  }

  // Function to format the height range as a string
  String getFormattedHeightRange() {
    final minHeightCm = currentRangeValues.start.round();
    final maxHeightCm = currentRangeValues.end.round();

    final minHeightInches = convertCmToInches(currentRangeValues.start);
    final maxHeightInches = convertCmToInches(currentRangeValues.end);

    return '$minHeightCm cm ($minHeightInches) - $maxHeightCm cm ($maxHeightInches)';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Height',
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pop(context, hasChanged ? data : null),
                    child: SizedBox.square(
                      dimension: 30.r,
                      child: hasChanged ? checkIcon() : cancelIcon(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.outlinedColor,
              height: 0,
            ),
            addHeight(16),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.inputBackGround,
              ),
              padding: EdgeInsets.symmetric(vertical: 12.h),
              margin: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Height Range',
                          style: TextStyles.prefText,
                        ),
                        AppChip(
                          data: getFormattedHeightRange(),
                          isSelected: false,
                          outlined: false,
                          padding: EdgeInsets.symmetric(
                              vertical: 4.h, horizontal: 8.w),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w)
                        .copyWith(top: 8.h),
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.activeTrackColor,
                        inactiveTrackColor: Colors.white,
                        thumbColor: Colors.white,
                      ),
                      child: RangeSlider(
                        onChanged: updateRange,
                        min: 140,
                        max: 220,
                        values: currentRangeValues,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            addHeight(14)
          ],
        ),
      ),
    );
  }
}
