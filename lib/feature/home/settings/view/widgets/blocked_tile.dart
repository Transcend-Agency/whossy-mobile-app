import 'package:flutter/material.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../constants/index.dart';

class BlockedTile extends StatelessWidget {
  const BlockedTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
       const AppDivider(),
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: pagePadding,
          child: Column(
            children: [
              PreferenceTile(
                text: 'Blocked Contacts',
                onTap: () {},
                trailing: 'none',
                showDivider: false,
              ),
            ],
          ),
        ),
       const AppDivider(),
      ],
    );
  }
}
