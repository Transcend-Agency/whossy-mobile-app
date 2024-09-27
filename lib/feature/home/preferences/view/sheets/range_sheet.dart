import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';

class RangeSheet<T> extends StatefulWidget {
  const RangeSheet({
    super.key,
    this.range,
    required this.type,
  });

  final RangeValues? range;
  final RangeType type;

  @override
  State<RangeSheet<T>> createState() => _RangeSheetState<T>();
}

class _RangeSheetState<T> extends State<RangeSheet<T>> {
  late RangeValues currentRange;
  late RangeValues store;
  bool hasChanged = false;

  void updateRange(RangeValues values) {
    setState(() {
      if (currentRange != values) {
        currentRange = values;
      }

      hasChanged = currentRange != store;
    });
  }

  @override
  void initState() {
    currentRange = widget.range ?? widget.type.placeholder;

    store = currentRange;
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
                    widget.type.name,
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(
                        context, hasChanged ? currentRange : null),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.type.name} Range',
                          style: TextStyles.prefText,
                        ),
                        AppChip(
                          data:
                              currentRange.getFormattedRange(type: widget.type),
                          isSelected: false,
                          outlined: false,
                          padding: EdgeInsets.symmetric(
                            vertical: 4.h,
                            horizontal: 8.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w)
                        .copyWith(top: 10.h),
                    child: AppRangeSlider(
                      onChanged: updateRange,
                      values: currentRange,
                      range: RangeValues(
                        widget.type.feasibleRange[0],
                        widget.type.feasibleRange[1],
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

Future<RangeValues?> showRangeSheet({
  required RangeValues? range,
  required BuildContext context,
  required RangeType type,
}) {
  return showModalBottomSheet<RangeValues?>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => RangeSheet(
      range: range,
      type: type,
    ),
  );
}
