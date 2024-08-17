import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/constants/asset_paths.dart';

import '../../utils/index.dart';
import '../../utils/router/router.gr.dart';
import '../Button/app_icon_button.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({super.key, this.icon});

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox.shrink(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) AppIconButton(icon: icon!),
            AppIconButton(
              path: AppAssets.tune,
              size: 24,
              onTap: () => Nav.push(context, const PreferenceRoute()),
            ),
          ],
        )
      ],
    );
  }
}
