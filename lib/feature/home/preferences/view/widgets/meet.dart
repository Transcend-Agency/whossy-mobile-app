import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/index.dart';
import 'package:whossy_app/feature/home/preferences/model/other_preferences.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';
import '../../../../auth/onboarding/data/source/meet_data.dart';
import '../../../../auth/onboarding/model/meet_model.dart';

class MeetComponent<T extends SearchPreferencesNotifier>
    extends StatefulWidget {
  const MeetComponent({super.key});

  @override
  State<MeetComponent<T>> createState() => _MeetComponentState();
}

class _MeetComponentState<T extends SearchPreferencesNotifier>
    extends State<MeetComponent<T>> {
  late T _notifier;
  Meet? meet;

  bool _hasUpdatedMeet = false;

  @override
  void initState() {
    _notifier = context.read<T>();

    super.initState();
  }

  void onChanged(Meet? newValue) {
    setState(() => meet = newValue);

    _notifier.updatePreferences(meet: newValue?.index);
  }

  @override
  Widget build(BuildContext context) {
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
                  if (prefs != null) {
                    if (!_hasUpdatedMeet) {
                      meet = Meet.values[prefs.meet ?? 2];

                      _hasUpdatedMeet = true;
                    }
                  }
                  return AppAnimatedSwitcher(
                    child: prefs == null
                        ? Wrap(
                            key: const ValueKey(false),
                            spacing: 12.w,
                            runSpacing: 8.h,
                            children: List.generate(3, (index) {
                              return ShimmerWidget.rectangular(
                                height: 25.h,
                                width: 88.w,
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
                                .map((_) => _buildGenderChip(_, onChanged))
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
  ) {
    return GenderChip<Meet?>(
      value: data.value,
      groupValue: meet,
      onChanged: onChanged,
      title: data.value.name,
      leadingWidget: data.icon != null
          ? Icon(
              data.icon,
              size: 24.r,
              color: data.value == meet ? Colors.white : null,
            )
          : Padding(
              padding: const EdgeInsets.only(right: 3, left: 2),
              child: Transform.scale(
                scale: 0.85,
                child: SvgPicture.asset(
                  data.asset!,
                  width: 20.r,
                  height: 20.r,
                  colorFilter: ColorFilter.mode(
                    data.value == meet ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
    );
  }
}
