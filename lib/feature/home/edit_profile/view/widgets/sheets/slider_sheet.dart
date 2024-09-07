import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
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
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: modalPadding.copyWith(
                top: AppUtils.scale(12.h),
                bottom: AppUtils.scale(12.h),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.rangeType.name,
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(
                        context, hasChanged ? currentValue : null),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.r),
                    child: AppChip(
                      data: currentValue.getFormattedRange(
                          type: widget.rangeType),
                      isSelected: false,
                      outlined: false,
                      padding: EdgeInsets.symmetric(
                        vertical: 4.h,
                        horizontal: 8.w,
                      ),
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
                      child: Slider.adaptive(
                        onChanged: updateValue,
                        min: widget.range.min,
                        max: widget.range.max,
                        value: currentValue,
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
