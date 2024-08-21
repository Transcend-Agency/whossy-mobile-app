import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';
import 'widgets/_.dart';

@RoutePage()
class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useScrollView: true,
      appBar: const CustomAppBar(
        title: 'Settings',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: const CoreSettingsList(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: const BlockedTile(),
          ),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: extraSettings.map((data) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: ExtraCoreSettings(title: data.name, route: data.route),
              );
            }).toList(),
          ),
          addHeight(16),
          Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: ExtraCoreSettings(
              customChildren: [
                SvgPicture.asset(AppAssets.logout, width: 18),
                addWidth(8),
                Text('Logout', style: TextStyles.prefText),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: ExtraCoreSettings(
              customChildren: [
                Text(
                  'Delete Account',
                  style: TextStyles.prefText.copyWith(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExtraSettingItem {
  final String name;
  final PageRouteInfo<dynamic>? route;

  ExtraSettingItem({required this.name, required this.route});
}

List<ExtraSettingItem> extraSettings = [
  ExtraSettingItem(name: 'Restore purchases', route: null),
  ExtraSettingItem(name: 'Whossy safety center', route: null),
  ExtraSettingItem(name: 'Community rules', route: null),
  ExtraSettingItem(name: 'Policies', route: null),
  ExtraSettingItem(name: 'Help & Support', route: null),
];
