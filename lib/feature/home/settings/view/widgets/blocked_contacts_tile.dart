import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/edit_profile/data/state/edit_profile_notifier.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../common/styles/component_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';

class BlockedContactsTile extends StatelessWidget {
  const BlockedContactsTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppDivider(),
        Selector<EditProfileNotifier, List<String>?>(
          selector: (_, editProfile) => editProfile.coreProfile?.blockedIds,
          builder: (_, blockedIds, __) {
            bool isEmpty = blockedIds == null || blockedIds.isEmpty;
            return Container(
              decoration: const BoxDecoration(color: AppColors.inputBackGround),
              padding: pagePadding,
              child: Column(
                children: [
                  PreferenceTile(
                    text: 'Blocked Contacts',
                    onTap: isEmpty
                        ? null
                        : () => Nav.push(
                            context, BlockedContacts(uids: blockedIds)),
                    trailing: getBlockedCount(blockedIds),
                    showDivider: false,
                  ),
                ],
              ),
            );
          },
        ),
        const AppDivider(),
      ],
    );
  }

  String getBlockedCount(List<String>? contacts) {
    if (contacts == null || contacts.isEmpty) {
      return 'none';
    }
    int count = contacts.length;

    if (count < 11) {
      return count.toString();
    } else {
      return "10+ blocked";
    }
  }
}
