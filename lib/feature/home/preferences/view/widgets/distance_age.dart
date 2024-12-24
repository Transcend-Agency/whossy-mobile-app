import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/preferences/model/other_preferences.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';

class DistanceAgeComponent<T extends SearchPreferencesNotifier>
    extends HookWidget {
  const DistanceAgeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<T>();

    final isAndroid = Platform.isAndroid;

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
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Distance Radius', style: TextStyles.prefText),
                        AppAnimatedSwitcher(
                          child: prefs == null
                              ? ShimmerWidget.rectangular(
                                  height: 24.h,
                                  width: 46.w,
                                  border: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  key: const ValueKey(false),
                                )
                              : AppChip(
                                  key: const ValueKey('data'),
                                  data: '${(prefs.distance ?? 50).toInt()} mi',
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
                              value: prefs.distance ?? 50,
                              onChanged: (newValue) => notifier
                                  .updatePreferences(distance: newValue),
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
                                  key: const ValueKey(false),
                                  padding: EdgeInsets.symmetric(vertical: 13.r)
                                      .copyWith(right: 11.r),
                                  child: const ShimmerSwitch(),
                                )
                              : Transform.scale(
                                  key: const ValueKey("data"),
                                  scale: 0.7,
                                  child: Switch.adaptive(
                                    value: prefs.outreach ?? true,
                                    onChanged: (value) => notifier
                                        .updatePreferences(outreach: value),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.r, vertical: 12.h),
                    child: const AppDivider(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.r),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Age range', style: TextStyles.prefText),
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
                                      '${prefs.toAgeRange()?.start.round() ?? 25} - ${prefs.toAgeRange()?.end.round() ?? 35}',
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
                              onChanged: (values) {
                                notifier.updatePreferences(
                                  minAge: values.start.toInt(),
                                  maxAge: values.end.toInt(),
                                );
                              },
                              values: prefs.toAgeRange() ??
                                  const RangeValues(25, 35),
                              range: const RangeValues(18, 70),
                            ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const AppDivider(),
      ],
    );
  }
}
