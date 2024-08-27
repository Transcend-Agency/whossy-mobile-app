import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../constants/index.dart';
import '../../../../preferences/view/widgets/extras.dart';
import '../../../data/source/edit_profile_data.dart';
import '../../../data/state/edit_profile_notifier.dart';

class ExtraEditProfileList extends StatelessWidget {
  const ExtraEditProfileList({super.key});

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
                  // PreferenceTile(
                  //   text: 'Height',
                  //   onTap: () async {
                  //     final height = await showRangeSheet(
                  //       context: context,
                  //       range: user.otherPreferences.toHeightRange(),
                  //       type: RangeType.height,
                  //     );
                  //
                  //     if (height != null) {
                  //       user.updatePreferences(
                  //         minHeight: height.start.round(),
                  //         maxHeight: height.end.round(),
                  //       );
                  //     }
                  //   },
                  //   trailing: user.otherPreferences.heightRange.displayRange(),
                  // ),
                  // PreferenceTile(
                  //   text: 'Weight',
                  //   onTap: () async {
                  //     final weight = await showRangeSheet(
                  //       context: context,
                  //       range: user.otherPreferences.toWeightRange(),
                  //       type: RangeType.weight,
                  //     );
                  //
                  //     if (weight != null) {
                  //       user.updatePreferences(
                  //         minWeight: weight.start.round(),
                  //         maxWeight: weight.end.round(),
                  //       );
                  //     }
                  //   },
                  //   trailing: user.otherPreferences.weightRange
                  //       .displayRange(type: RangeType.weight),
                  // ),
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
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
      ],
    );
  }
}
