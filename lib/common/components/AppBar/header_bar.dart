import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/constants/asset_paths.dart';

import '../../utils/index.dart';
import '../../utils/router/router.gr.dart';
import '../Button/app_icon_button.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar(
      {super.key, this.icon, this.onIconTap, this.onTuneTap, this.child});

  final IconData? icon;
  final VoidCallback? onIconTap;
  final VoidCallback? onTuneTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        addHeight(MediaQuery.of(context).padding.top),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            child ?? const SizedBox.shrink(),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null)
                  Padding(
                    padding: EdgeInsets.only(right: 2.w),
                    child: AppIconButton(
                      icon: icon!,
                      onTap: onIconTap,
                    ),
                  ),
                AppIconButton(
                  path: AppAssets.tune,
                  size: 24,
                  onTap: onTuneTap ??
                      () => Nav.push(context, const PreferenceRoute()),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
