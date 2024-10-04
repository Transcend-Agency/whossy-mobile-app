import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../../model/data_range.dart';

class SliderSheet<T> extends StatefulWidget {
  const SliderSheet({
    super.key,
    this.value,
    required this.range,
    required this.rangeType,
  });

  final double? value;
  final DataRange range;
  final RangeType rangeType;

  @override
  State<SliderSheet> createState() => _SliderSheetState();
}

class _SliderSheetState extends State<SliderSheet> {
  bool hasChanged = false;
  late double currentValue;
  late double store;

  void updateValue(double value) {
    setState(() {
      if (currentValue != value) {
        currentValue = value;
      }

      hasChanged = currentValue != store;
    });
  }

  @override
  void initState() {
    currentValue = widget.value ?? widget.range.midpoint;

    store = currentValue;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppSheetScaffold(
      title: widget.rangeType.name,
      topPadding: 16,
      onExit: () => Navigator.pop(context, hasChanged ? currentValue : null),
      exitIcon: hasChanged ? checkIcon() : cancelIcon(),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: AppColors.inputBackGround,
        ),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        margin: EdgeInsets.symmetric(horizontal: 14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.r),
                child: AppChip(
                  data: currentValue.getFormattedRange(type: widget.rangeType),
                  isSelected: false,
                  outlined: false,
                  padding: EdgeInsets.symmetric(
                    vertical: 4.h,
                    horizontal: 8.w,
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 12.w).copyWith(top: 8.h),
              child: AppSlider(
                useSliderTheme: true,
                onChanged: updateValue,
                range: RangeValues(widget.range.min, widget.range.max),
                value: currentValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
