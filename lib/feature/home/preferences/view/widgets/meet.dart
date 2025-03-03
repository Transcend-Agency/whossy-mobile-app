import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/utils.dart';
import 'package:whossy_app/feature/home/preferences/model/other_preferences.dart';

import '../../../../../common/components/components.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';
import '../../../../auth/onboarding/data/source/meet_data.dart';
import '../../../../auth/onboarding/model/meet_model.dart';
import '../../data/state/search_preferences_notifier.dart';

class MeetComponent<T extends SearchPreferencesNotifier> extends HookWidget {
  const MeetComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<T>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppDivider(),
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: EdgeInsets.all(14.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'I want to meet',
                style: TextStyles.prefText,
              ),
              addHeight(10.h),
              Selector<T, OtherPreferences?>(
                selector: (_, notifier) => notifier.otherPreferences,
                builder: (_, prefs, __) {
                  return AppAnimatedSwitcher(
                    child: prefs == null
                        ? Wrap(
                            key: const ValueKey(false),
                            spacing: 12.w,
                            runSpacing: 8.h,
                            children: List.generate(3, (index) {
                              return ShimmerWidget.rectangular(
                                height: 22.h,
                                width: 62.w,
                                border: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              );
                            }),
                          )
                        : Wrap(
                            key: const ValueKey('data'),
                            spacing: 12.w,
                            runSpacing: 8.h,
                            children: meetData
                                .map(
                                  (data) => _buildGenderChip(
                                    data,
                                    (value) => notifier.updatePreferences(
                                        meet: value?.index),
                                    Meet.values[prefs.meet ?? 2],
                                  ),
                                )
                                .toList(),
                          ),
                  );
                },
              )
            ],
          ),
        ),
        const AppDivider(),
      ],
    );
  }

  Widget _buildGenderChip<U extends SearchPreferencesNotifier>(
    MeetModel data,
    void Function(Meet?) onChanged,
    Meet? selectedMeet,
  ) {
    return GenderChip<Meet?>(
      value: data.value,
      groupValue: selectedMeet,
      onChanged: onChanged,
      title: data.value.name,
      leadingWidget: data.icon != null
          ? Icon(
              data.icon,
              size: 25,
              color: data.value == selectedMeet ? Colors.white : null,
            )
          : Padding(
              padding: const EdgeInsets.only(right: 4, left: 2),
              child: SvgPicture.asset(
                data.asset!,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(
                  data.value == selectedMeet ? Colors.white : Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
    );
  }
}
