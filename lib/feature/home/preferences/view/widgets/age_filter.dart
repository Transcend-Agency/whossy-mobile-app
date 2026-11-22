import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../common/components/components.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/provider.dart';

/// The age filter: off by default, with a note saying what it does before
/// anyone switches it on. When it's on, only people in the range are shown
/// when swiping and in Advanced Search.
///
/// It always edits the Preferences age filter, so Preferences and Advanced
/// Search show and change the same setting. [standalone] adds the divider
/// and grey panel it needs on a screen of its own (Advanced Search); inside
/// the Preferences distance panel it sits under the distance slider.
class AgeFilterComponent extends StatelessWidget {
  const AgeFilterComponent({super.key, this.standalone = false});

  final bool standalone;

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<PreferencesNotifier>();
    final prefs = notifier.otherPreferences;
    final isOn = prefs?.isAgeFilterOn ?? false;
    final range = prefs?.toAgeRange();

    void toggle(bool on) {
      final dateOfBirth =
          context.read<EditProfileNotifier>().staticProfile?.dateOfBirth;
      notifier.setAgeFilter(on, startingRange: startingAgeRange(dateOfBirth));
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 14.r, right: 4.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter by age', style: TextStyles.prefText),
              AppAnimatedSwitcher(
                child: prefs == null
                    ? Padding(
                        key: const ValueKey(false),
                        padding: EdgeInsets.symmetric(vertical: 15.r)
                            .copyWith(right: 7.w),
                        child: const ShimmerSwitch(),
                      )
                    : Transform.scale(
                        key: const ValueKey('data'),
                        scale: 0.7,
                        child: Switch.adaptive(
                          value: isOn,
                          onChanged: toggle,
                        ),
                      ),
              ),
            ],
          ),
        ),
        if (isOn && range != null) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Age range', style: TextStyles.prefText),
                AppChip(
                  data: '${range.start.round()} - ${range.end.round()}',
                  isSelected: false,
                  outlined: false,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.r)
                .copyWith(top: Platform.isAndroid ? 10.h : 8.h),
            child: AppRangeSlider(
              values: range,
              range: kAgeSliderSpan,
              onChanged: (values) => notifier.updatePreferences(
                minAge: values.start.round(),
                maxAge: values.end.round(),
              ),
            ),
          ),
        ],
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.r)
              .copyWith(top: isOn ? 8.h : 0),
          child: Text(
            isOn
                ? AppStrings.ageFilterOnNote
                : standalone
                    ? AppStrings.ageFilterOffNoteAdvancedSearch
                    : AppStrings.ageFilterOffNote,
            style: TextStyles.hintText,
          ),
        ),
      ],
    );

    if (!standalone) return content;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppDivider(),
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: EdgeInsets.symmetric(vertical: 14.r),
          child: content,
        ),
        const AppDivider(),
      ],
    );
  }
}
