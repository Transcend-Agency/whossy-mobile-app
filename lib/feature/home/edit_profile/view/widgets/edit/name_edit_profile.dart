import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../../../common/styles/component_style.dart';
import '../../../../../../constants/index.dart';
import '../../../data/state/edit_profile_notifier.dart';
import '../sheets/name_sheet.dart';

@RoutePage()
class NameEditProfile extends StatelessWidget {
  const NameEditProfile({super.key, required this.names});

  final Map<String, String?> names;

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
                    children: [
                      PreferenceTile(
                        text: "First name",
                        onTap: () async {
                          final name = await showNameSheet(
                            context: context,
                            name: names['firstName'],
                            title: "First name",
                          );
                        },
                        trailing: names["firstName"] ?? 'No name set',
                        showTrailingIcon: false,
                        showDivider: true,
                      ),
                      PreferenceTile(
                        text: "Last name",
                        onTap: () async {
                          final name = await showNameSheet(
                            context: context,
                            name: names['lastName'],
                            title: "Last name",
                          );
                        },
                        trailing: names["lastName"] ?? 'No name set',
                        showTrailingIcon: false,
                        showDivider: false,
                      ),
                    ],
                  );
                },
              )),
          const Divider(
            color: AppColors.outlinedColor,
            height: 0,
          ),
        ],
      ),
    );
  }
}

Future<String?> showNameSheet({
  required BuildContext context,
  String? name,
  required String title,
}) {
  return showModalBottomSheet<String?>(
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => NameSheet(name: name, title: title),
  );
}
