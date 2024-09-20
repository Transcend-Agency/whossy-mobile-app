import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/debouncer.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';

class DistanceAgeComponent extends StatefulWidget {
  const DistanceAgeComponent({super.key});

  @override
  State<DistanceAgeComponent> createState() => _DistanceAgeComponentState();
}

class _DistanceAgeComponentState extends State<DistanceAgeComponent> {
  final _debouncer = Debouncer(milliseconds: 500);
  late RangeValues ageRange;
  late PreferencesNotifier _prefsNotifier;

  late double distance;
  late bool show;

  @override
  void initState() {
    _prefsNotifier = context.read<PreferencesNotifier>();

    ageRange = _prefsNotifier.otherPreferences?.toAgeRange() ??
        const RangeValues(25, 35);

    distance = _prefsNotifier.otherPreferences?.distance ?? 50;

    show = _prefsNotifier.otherPreferences?.outreach ?? true;

    super.initState();
  }

  void onChanged(double newValue) {
    setState(() => distance = newValue);

    _debouncer.run(() => _prefsNotifier.updatePreferences(distance: newValue));
  }

  void updateSwitch(bool newValue) {
    setState(() => show = newValue);

    _prefsNotifier.updatePreferences(outreach: newValue);
  }

  void updateRange(RangeValues values) {
    setState(() => ageRange = values);

    _debouncer.run(
      () => _prefsNotifier.updatePreferences(
        minAge: values.start.toInt(),
        maxAge: values.end.toInt(),
      ),
    );
  }

  final isAndroid = Platform.isAndroid;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: EdgeInsets.symmetric(vertical: 14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Distance Radius',
                      style: TextStyles.prefText,
                    ),
                    AppChip(
                      data: '${distance.toInt()} mi',
                      isSelected: false,
                      outlined: false,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.r,
                  vertical: isAndroid ? 8.h : 4.h,
                ),
                child: AppSlider(
                  useSliderTheme: true,
                  value: distance,
                  onChanged: onChanged,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Text(
                          'Show people outside my distance radius and country for better reach',
                          style: TextStyles.prefText
                              .copyWith(color: AppColors.hintTextColor),
                        ),
                      ),
                    ),
                    Transform.scale(
                      scale: 0.7,
                      child: Switch.adaptive(
                        value: show,
                        onChanged: updateSwitch,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 12.h),
                child: const Divider(
                  color: AppColors.outlinedColor,
                  height: 0,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Age range',
                      style: TextStyles.prefText,
                    ),
                    AppChip(
                      data:
                          '${ageRange.start.round()} - ${ageRange.end.round()}',
                      isSelected: false,
                      outlined: false,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.r)
                    .copyWith(top: isAndroid ? 10.h : 8.h),
                child: AppRangeSlider(
                  onChanged: updateRange,
                  values: ageRange,
                  range: const RangeValues(18, 70),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
      ],
    );
  }
}
