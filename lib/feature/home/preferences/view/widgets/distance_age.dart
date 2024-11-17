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

    // State variables using hooks
    final distance = useState<double>(50);
    final show = useState<bool>(true);
    final ageRange = useState<RangeValues>(const RangeValues(25, 35));

    final hasUpdatedDistance = useState(false);
    final hasUpdatedAgeRange = useState(false);
    final hasUpdatedShow = useState(false);

    final debouncedDistance = useDebounced(
      distance.value,
      const Duration(milliseconds: 500),
    );

    final debouncedAgeRange = useDebounced(
      ageRange.value,
      const Duration(milliseconds: 500),
    );

    useEffect(() {
      final prefs = notifier.otherPreferences;
      if (prefs != null) {
        if (!hasUpdatedDistance.value) {
          distance.value = prefs.distance ?? 50;
          hasUpdatedDistance.value = true;
        }

        if (!hasUpdatedAgeRange.value) {
          ageRange.value = prefs.toAgeRange() ?? const RangeValues(25, 35);
          hasUpdatedAgeRange.value = true;
        }

        if (!hasUpdatedShow.value) {
          show.value = prefs.outreach ?? true;
          hasUpdatedShow.value = true;
        }
      }
      return null;
    }, [notifier.otherPreferences]);

    void updateSwitch(bool newValue) {
      show.value = newValue;
      notifier.updatePreferences(outreach: newValue);
    }

    // Callbacks for updating preferences
    useEffect(() {
      if (debouncedDistance != null) {
        notifier.updatePreferences(distance: debouncedDistance);
      }
      return null;
    }, [debouncedDistance]);

    useEffect(() {
      if (debouncedAgeRange != null) {
        // Todo: Check this out
        WidgetsBinding.instance.addPostFrameCallback((_) {
          notifier.updatePreferences(
            minAge: debouncedAgeRange.start.toInt(),
            maxAge: debouncedAgeRange.end.toInt(),
          );
        });
      }
      return null;
    }, [debouncedAgeRange]);

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
                                  height: 25.h,
                                  width: 48.w,
                                  border: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  key: const ValueKey(false),
                                )
                              : AppChip(
                                  key: const ValueKey('data'),
                                  data: '${distance.value.toInt()} mi',
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
                              value: distance.value,
                              onChanged: (newValue) {
                                distance.value =
                                    newValue; // Update the local state
                              },
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
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    key: const ValueKey(false),
                                  ),
                                )
                              : Transform.scale(
                                  key: const ValueKey("data"),
                                  scale: 0.7,
                                  child: Switch.adaptive(
                                    value: show.value,
                                    onChanged: updateSwitch,
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
                                      '${ageRange.value.start.round()} - ${ageRange.value.end.round()}',
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
                                ageRange.value = values; // Update local state
                              },
                              values: ageRange.value,
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
