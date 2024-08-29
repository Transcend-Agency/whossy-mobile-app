import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../../data/state/edit_profile_notifier.dart';
import '../../../model/core_profile.dart';

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
    final coreProfile = profile.coreProfile;

    // log('The value of core profile is ${coreProfile.toString()}');
    if (coreProfile == null) return null;

    switch (key) {
      case 'name':
        if (coreProfile.hasFullName) {
          return () => Nav.push(
                context,
                NameEditProfile(names: coreProfile.getName()),
              );
        }
        break;
      case 'gender':
        // Handle gender case
        break;
      case 'email':
        // Handle email case
        break;
      case 'phoneNumber':
        // Handle phone number case
        break;
      case 'birthday':
        return null; // No action needed for "birthday"
    }

    return null;
  }
}
