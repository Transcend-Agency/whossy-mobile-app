import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../../../constants/index.dart';
import '../../../data/state/edit_profile_notifier.dart';
import '../sheets/name_sheet.dart';

@RoutePage()
class NameEditProfile extends StatelessWidget {
  const NameEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const CustomAppBar(
        title: 'Edit Name',
        showAction: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          addHeight(8),
          const AppDivider(),
          Container(
              decoration: const BoxDecoration(color: AppColors.inputBackGround),
              padding: EdgeInsets.symmetric(horizontal: 14.r),
              child: Consumer<EditProfileNotifier>(
                builder: (_, profile, __) {
                  return Column(
                    children: [
                      PreferenceTile(
                        text: "First name",
                        onTap: () async {
                          final name = await showNameSheet(
                            context: context,
                            name:
                                profile.getCoreValue("full_name")["firstName"],
                            title: "First name",
                          );

                          if (name != null) {
                            profile.updateProfile(firstName: name);
                          }
                        },
                        trailing:
                            profile.getCoreValue("full_name")["firstName"] ??
                                'No name set',
                        showTrailingIcon: false,
                        showDivider: true,
                      ),
                      PreferenceTile(
                        text: "Last name",
                        onTap: () async {
                          final name = await showNameSheet(
                            context: context,
                            name: profile.getCoreValue("full_name")["lastName"],
                            title: "Last name",
                          );

                          if (name != null) {
                            profile.updateProfile(lastName: name);
                          }
                        },
                        trailing:
                            profile.getCoreValue("full_name")["lastName"] ??
                                'No name set',
                        showTrailingIcon: false,
                        showDivider: false,
                      ),
                    ],
                  );
                },
              )),
          const AppDivider(),
        ],
      ),
    );
  }
}
