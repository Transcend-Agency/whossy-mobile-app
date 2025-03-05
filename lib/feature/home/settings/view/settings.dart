import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/components.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';
import '../../../../common/utils/utils.dart';
import '../../../../provider/provider.dart';
import '../data/source/extra_settings_data.dart';
import 'widgets/widgets.dart';

@RoutePage()
class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  // Adjusted method to return Future<bool?>?
  Future<bool?>? _handleLogout() async {
    bool? result = await showConfirmationDialog(
      context,
      title: 'Confirm Log out',
      content: contentText(AppStrings.logout),
      yes: 'Log out',
      no: 'Cancel',
    );

    if (result == null) return null;

    if (result && mounted) {
      resetAllNotifiers(context);

      await context.read<SettingsNotifier>().signOut(
            (msg) => showSnackbar(msg, context),
          );

      if (!mounted) return null;

      Nav.replaceAll(context, [const LoginRoute()]);
    }

    return result;
  }

  Future<bool?> takeTutorial() async {
    final startTour = await showConfirmationDialog(
      context,
      title: 'Start Guided Tour',
      yes: 'Let\'s go!',
      content: contentText(AppStrings.startTutorial),
    );

    if (startTour == true && mounted) {
      Navigator.pop<String>(context, AppStrings.startTour);
      // context.read<TutorialNotifier>().startTutorial();
    }

    return startTour;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      useScrollView: true,
      appBar: const CustomAppBar(
        title: 'Settings',
        addBarHeight: 4,
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
            child: const BlockedContactsTile(),
          ),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: extraSettings.map((data) {
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: ExtraCoreSettings(
                  title: data.name,
                  route: data.route,
                  onTap:
                      data.name == 'Guided Tour' ? () => takeTutorial() : null,
                ),
              );
            }).toList(),
          ),
          addHeight(16),
          Padding(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Selector<ConnectivityNotifier, bool>(
              selector: (_, connection) => connection.isConnected,
              builder: (_, isOnline, __) {
                return ExtraCoreSettings(
                  onTap: isOnline
                      ? () async => await _handleLogout()
                      : () async {
                          showSnackbar(AppStrings.deviceOffline, context);
                          return null;
                        },
                  customChildren: [
                    SvgPicture.asset(AppAssets.logout, width: 18),
                    addWidth(8),
                    Text('Logout', style: TextStyles.prefText),
                  ],
                );
              },
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
