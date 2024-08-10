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
  RangeValues currentRangeValues = const RangeValues(18, 50);
  final _debouncer = Debouncer(milliseconds: 500);
  late UserNotifier _userNotifier;

  double distance = 50;
  bool show = true;

  @override
  void initState() {
    _userNotifier = Provider.of<UserNotifier>(context, listen: false);
    super.initState();
  }

  void onChanged(double newValue) {
    setState(() => distance = newValue);

    _debouncer.run(() => _userNotifier.updatePreferences(distance: newValue));
  }

  void updateSwitch(bool newValue) {
    setState(() => show = newValue);

    _userNotifier.updatePreferences(outreach: newValue);
  }

  void updateRange(RangeValues values) {
    setState(() => currentRangeValues = values);

    _debouncer.run(
      () => _userNotifier.updatePreferences(
        minAge: values.start.toInt(),
        maxAge: values.end.toInt(),
      ),
    );
  }

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
                padding: EdgeInsets.symmetric(horizontal: 6.r, vertical: 8.h),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 1,
                    activeTrackColor: AppColors.activeTrackColor,
                    inactiveTrackColor: Colors.white,
                    thumbColor: Colors.white,
                  ),
                  child: Slider.adaptive(
                    value: distance,
                    onChanged: onChanged,
                    min: 0,
                    max: 100,
                  ),
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
                          '${currentRangeValues.start.round()} - ${currentRangeValues.end.round()}',
                      isSelected: false,
                      outlined: false,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 6.r).copyWith(top: 8.h),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: AppColors.activeTrackColor,
                    inactiveTrackColor: Colors.white,
                    thumbColor: Colors.white,
                  ),
                  child: RangeSlider(
                    onChanged: updateRange,
                    min: 18,
                    max: 100,
                    values: currentRangeValues,
                  ),
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
