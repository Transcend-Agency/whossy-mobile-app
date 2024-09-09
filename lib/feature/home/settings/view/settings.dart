import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/index.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/settings/data/state/settings_notifier.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';
import '../data/source/extra_settings_data.dart';
import 'widgets/_.dart';

@RoutePage()
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

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
              onTap: () async {
                bool? result = await showConfirmationDialog(
                  context,
                  title: 'Logout',
                  content: 'Are you sure you want to logout?',
                );

                if (result == null || !context.mounted) return;

                if (result) {
                  await context.read<SettingsNotifier>().signOut(showSnackbar);

                  if (!context.mounted) return;

                  Nav.replaceAll(context, [const LoginRoute()]);
                }

                return null;
              },
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
