import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';

import '../../../../../../constants/index.dart';
import '../../data/source/core_settings_text_data.dart';
import 'core_settings_tile.dart';

class CoreSettings extends StatelessWidget {
  const CoreSettings({super.key});

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
            padding: pagePadding,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: coreSettingItems.map((data) {
                return CoreSettingsTile(
                  title: data.title,
                  subtitle: data.subtitle,
                  isPremium: data.isPremium,
                  switchValue: true,
                  onSwitchChanged: (_) {},
                );
              }).toList(),
            )),
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
      ],
    );
  }
}
