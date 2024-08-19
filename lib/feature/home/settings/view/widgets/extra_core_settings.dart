import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/common/components/index.dart';

import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class ExtraCoreSettings extends StatelessWidget {
  final String? title;
  final PageRouteInfo<dynamic>? route;
  final List<Widget>? customChildren;

  const ExtraCoreSettings({
    super.key,
    this.title,
    this.route,
    this.customChildren,
  });

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
          child: Column(
            children: [
              PreferenceTile(
                text: title,
                onTap: () => Nav.push(context, route),
                trailing: '',
                showDivider: false,
                customChildren: customChildren,
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
      ],
    );
  }
}
