import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/preferences/model/other_preferences.dart';

import '../../../../../common/components/components.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/provider.dart';
import 'age_filter.dart';

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
                              value: (prefs.distance ?? 50).toDouble(),
                              onChanged: (newValue) =>
                                  notifier.updatePreferences(
                                distance: newValue.toInt(),
                              ),
                            ),
                    ),
                  ),
                  // Says what the radius does, so nobody takes it for a
                  // hard limit on who they can see.
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14.r),
                    child: Text(
                      AppStrings.distanceRadiusNote,
                      style: TextStyles.hintText,
                    ),
                  ),
                  // C6: "outreach" toggle removed — MatchRepository no longer
                  // caps reach by radius at all (distance is a ranking signal,
                  // not a cutoff), so a toggle promising to bypass a cap that
                  // no longer exists would be its own new instance of exactly
                  // the bug this plan exists to fix.
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.r, vertical: 12.h),
                    child: const AppDivider(),
                  ),
                  // Age is its own component: it always edits the Preferences
                  // age filter, wherever it's shown (Advanced Search too).
                  const AgeFilterComponent(),
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
