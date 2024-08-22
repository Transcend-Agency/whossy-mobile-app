import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/utils/extensions.dart';
import 'package:whossy_mobile_app/feature/home/edit_profile/data/state/edit_profile_notifier.dart';
import 'package:whossy_mobile_app/feature/home/edit_profile/model/core_profile.dart';

import '../../../../../../constants/index.dart';

class CoreEditProfileList extends StatelessWidget {
  const CoreEditProfileList({super.key});

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
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: CoreProfile.validKeys.length - 1,
                itemBuilder: (context, index) {
                  String key = CoreProfile.validKeys[index];
                  return PreferenceTile(
                    text: key.toReadableFormat(),
                    onTap: () {},
                    trailing: profile.getCoreValue(key),
                    showDivider: index != CoreProfile.validKeys.length - 2,
                  );
                },
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
