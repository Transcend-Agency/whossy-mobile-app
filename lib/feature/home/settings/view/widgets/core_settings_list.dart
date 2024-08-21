import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/feature/home/settings/data/state/settings_notifier.dart';

import '../../../../../../constants/index.dart';
import '../../data/source/core_settings_text_data.dart';
import 'core_settings_tile.dart';

class CoreSettingsList extends StatelessWidget {
  const CoreSettingsList({super.key});

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
            child: Consumer<SettingsNotifier>(
              builder: (_, settings, __) {
                return ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: coreSettingItems.map((data) {
                    return CoreSettingsTile(
                      title: data.value.name,
                      subtitle: data.value.subtitle,
                      isPremium: data.isPremium,
                      switchValue: settings.getValue(data.value),
                      onSwitchChanged: (_) =>
                          settings.updateSwitch(data.value, _),
                    );
                  }).toList(),
                );
              },
            )),
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
      ],
    );
  }
}
