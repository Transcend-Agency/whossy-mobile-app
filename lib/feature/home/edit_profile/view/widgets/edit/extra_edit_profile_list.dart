import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/edit_profile/model/data_range.dart';
import 'package:whossy_app/feature/home/edit_profile/view/widgets/sheets/slider_sheet.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../../data/source/edit_profile_data.dart';
import '../../../data/state/edit_profile_notifier.dart';

class ExtraEditProfileList extends StatelessWidget {
  const ExtraEditProfileList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppDivider(),
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: EdgeInsets.symmetric(horizontal: 14.r),
          child: Consumer<EditProfileNotifier>(
            builder: (_, profile, __) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: editProfileData.length - 7,
                    itemBuilder: (_, index) {
                      final item = editProfileData[index];

                      return PreferenceTile(
                        key: ValueKey(index),
                        text: item.header,
                        onTap: () async {
                          final value = await showCustomModalBottomSheet(
                            selectedItem: profile.getSelected(item.type),
                            context: context,
                            item: item,
                          );

                          if (value != null) {
                            profile.setValue(value);
                          }
                        },
                        trailing: profile.getValue(item.type),
                      );
                    },
                  ),
                  PreferenceTile(
                    text: 'Height',
                    onTap: () async {
                      final height = await showRangeSheet(
                        context: context,
                        range: DataRange(min: 140, max: 220),
                        type: RangeType.height,
                        value: profile.coreProfile?.height,
                      );

                      if (height != null) {
                        profile.updateProfile(height: height);
                      }
                    },
                    trailing: profile.coreProfile?.height
                            ?.getFormattedRange(type: RangeType.height) ??
                        'Choose',
                  ),
                  PreferenceTile(
                    text: 'Weight',
                    onTap: () async {
                      final weight = await showRangeSheet(
                        context: context,
                        range: DataRange(min: 40, max: 220),
                        type: RangeType.weight,
                      );

                      if (weight != null) {
                        profile.updateProfile(weight: weight);
                      }
                    },
                    trailing: profile.coreProfile?.weight
                            ?.getFormattedRange(type: RangeType.weight) ??
                        'Choose',
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 7,
                    itemBuilder: (_, index) {
                      final item = editProfileData[index + 5];

                      return PreferenceTile(
                        key: ValueKey(index),
                        text: item.header,
                        onTap: () async {
                          final value = await showCustomModalBottomSheet(
                            selectedItem: profile.getSelected(item.type),
                            context: context,
                            item: item,
                          );

                          if (value != null) {
                            profile.setValue(value);
                          }
                        },
                        trailing: profile.getValue(item.type),
                        showDivider: index < 6,
                      ); //
                    },
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

Future<double?> showRangeSheet({
  required BuildContext context,
  required RangeType type,
  required DataRange range,
  double? value,
}) {
  return showModalBottomSheet<double?>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => SliderSheet(
      range: range,
      rangeType: type,
      value: value,
    ),
  );
}
