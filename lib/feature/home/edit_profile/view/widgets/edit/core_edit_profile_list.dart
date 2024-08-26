import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';
import 'package:whossy_mobile_app/feature/home/edit_profile/data/state/edit_profile_notifier.dart';
import 'package:whossy_mobile_app/feature/home/edit_profile/model/core_profile.dart';

import '../../../../../../common/utils/index.dart';
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
                    onTap: handleTap(key, context, profile),
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

  VoidCallback? handleTap(
      String key, BuildContext context, EditProfileNotifier profile) {
    if (key == "birthday") {
      // No action needed for "birthday"
      return null;
    } else {
      return () async {
        if (key == 'name') {
          Nav.push(
            context,
            NameEditProfile(
              names: profile.coreProfile.getName(),
            ),
          );
        } else if (key == 'gender') {
          // Handle gender case
        } else if (key == 'email') {
          // Handle email case
        } else if (key == 'phoneNumber') {
          // Handle phone number case
        }
      };
    }
  }
}
