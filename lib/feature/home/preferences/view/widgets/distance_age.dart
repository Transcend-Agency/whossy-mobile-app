import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/preferences/model/other_preferences.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/debouncer.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';

class DistanceAgeComponent<T extends SearchPreferencesNotifier>
    extends StatefulWidget {
  const DistanceAgeComponent({super.key});

  @override
  State<DistanceAgeComponent<T>> createState() => _DistanceAgeComponentState();
}

class _DistanceAgeComponentState<T extends SearchPreferencesNotifier>
    extends State<DistanceAgeComponent<T>> {
  late T _notifier;

  late bool show;
  late double distance;
  late RangeValues ageRange;

  bool _hasUpdatedDistance = false;
  bool _hasUpdatedAgeRange = false;
  bool _hasUpdatedShow = false;

  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void initState() {
    _notifier = context.read<T>();

    super.initState();
  }

  void onChanged(double newValue) {
    setState(() => distance = newValue);

    _debouncer.run(() => _notifier.updatePreferences(distance: newValue));
  }

  void updateSwitch(bool newValue) {
    setState(() => show = newValue);

    _notifier.updatePreferences(outreach: newValue);
  }

  void updateRange(RangeValues values) {
    setState(() => ageRange = values);

    _debouncer.run(
      () => _notifier.updatePreferences(
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
        const AppDivider(),
        Container(
            decoration: const BoxDecoration(color: AppColors.inputBackGround),
            padding: EdgeInsets.symmetric(vertical: 14.r),
            child: Selector<T, OtherPreferences?>(
              selector: (_, notifier) => notifier.otherPreferences,
              builder: (_, prefs, __) {
                if (prefs != null) {
                  if (!_hasUpdatedDistance) {
                    distance = prefs.distance ?? 50;

                    _hasUpdatedDistance = true;
                  }

                  if (!_hasUpdatedAgeRange) {
                    ageRange = prefs.toAgeRange() ?? const RangeValues(25, 35);

                    _hasUpdatedAgeRange = true;
                  }

                  if (!_hasUpdatedShow) {
                    show = prefs.outreach ?? true;

                    _hasUpdatedShow = true;
                  }
                }
                return Column(
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
                          AppAnimatedSwitcher(
                            child: prefs == null
                                ? ShimmerWidget.rectangular(
                                    height: 25.h,
                                    width: 48.w,
                                    border: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    key: const ValueKey(false),
                                  )
                                : AppChip(
                                    key: const ValueKey('data'),
                                    data: '${distance.toInt()} mi',
                                    isSelected: false,
                                    outlined: false,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.r,
                        vertical: isAndroid ? 8.h : 4.h,
                      ),
                      child: AppAnimatedSwitcher(
                        child: prefs == null
                            ? ShimmerWidget.rectangular(
                                height: 20.h,
                                border: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                key: const ValueKey(false),
                              )
                            : AppSlider(
                                key: const ValueKey('data'),
                                useSliderTheme: true,
                                value: distance,
                                onChanged: onChanged,
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
                          AppAnimatedSwitcher(
                            child: prefs == null
                                ? Padding(
                                    padding: EdgeInsets.all(11.r),
                                    child: ShimmerWidget.rectangular(
                                      height: 24.h,
                                      width: 37.w,
                                      border: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                      ),
                                      key: const ValueKey(false),
                                    ),
                                  )
                                : Transform.scale(
                                    key: const ValueKey("data"),
                                    scale: 0.7,
                                    child: Switch.adaptive(
                                      value: show,
                                      onChanged: updateSwitch,
                                    ),
                                  ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 14.r, vertical: 12.h),
                      child:  const AppDivider(),
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
                          AppAnimatedSwitcher(
                            child: prefs == null
                                ? ShimmerWidget.rectangular(
                                    height: 25.h,
                                    width: 58.w,
                                    border: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    key: const ValueKey(false),
                                  )
                                : AppChip(
                                    key: const ValueKey('data'),
                                    data:
                                        '${ageRange.start.round()} - ${ageRange.end.round()}',
                                    isSelected: false,
                                    outlined: false,
                                  ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.r)
                          .copyWith(top: isAndroid ? 10.h : 8.h),
                      child: AppAnimatedSwitcher(
                        child: prefs == null
                            ? ShimmerWidget.rectangular(
                                height: 20.h,
                                border: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                key: const ValueKey(false),
                              )
                            : AppRangeSlider(
                                key: const ValueKey('data'),
                                onChanged: updateRange,
                                values: ageRange,
                                range: const RangeValues(18, 70),
                              ),
                      ),
                    ),
                  ],
                );
              },
            )),
        const AppDivider(),
      ],
    );
  }
}
