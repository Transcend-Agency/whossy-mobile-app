import 'package:flutter/material.dart';
import 'package:whossy_app/constants/asset_paths.dart';

import '../../utils/index.dart';
import '../../utils/router/router.gr.dart';
import '../Button/app_icon_button.dart';

class HeaderBar extends StatelessWidget {
  const HeaderBar({
    super.key,
    this.icon,
    this.onIconTap,
    this.onIcon2Tap,
    this.child,
    this.icon2,
    this.topPadding = 4, //8
  });

  final String? icon;
  final String? icon2;
  final double topPadding;
  final VoidCallback? onIconTap;
  final VoidCallback? onIcon2Tap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        addHeight(MediaQuery.paddingOf(context).top + topPadding),
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 6, right: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              child ?? const SizedBox.shrink(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    GestureDetector(
                      onTap: onIconTap,
                      child: Container(
                        margin: const EdgeInsets.all(9),
                        child: svgIcon(
                          icon!,
                          color: Colors.black,
                          size: 18,
                        ),
                      ),
                    ),
                    addWidth(2),
                  ],
                  AppIconButton(
                    path: icon2 ?? AppAssets.tune,
                    size: 24,
                    onTap: onIcon2Tap ??
                        () => Nav.push(context, const PreferenceRoute()),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
