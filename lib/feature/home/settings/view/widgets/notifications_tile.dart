import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart' show openAppSettings;

import '../../../../../common/components/components.dart';
import '../../../../../common/styles/component_style.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/services/services.dart';
import '../../../../../common/utils/widget_functions.dart';
import '../../../../../constants/index.dart';
import '../../../../auth/sign_up/data/repository/user_repository.dart';

/// Shows whether the phone lets Whossy send notifications and gives a way
/// back after "Don't allow": Android stops showing its prompt after that,
/// and iOS never shows it again, so the phone's settings are the only way
/// to turn them on.
class NotificationsTile extends StatefulWidget {
  const NotificationsTile({
    super.key,
    this.readAccess,
    this.requestAccess,
    this.openSettings,
    this.onTurnedOn,
  });

  // Overridable for tests; default to the real notification service.
  final Future<NotificationAccess> Function()? readAccess;
  final Future<NotificationAccess> Function()? requestAccess;
  final Future<void> Function()? openSettings;
  final Future<void> Function()? onTurnedOn;

  @override
  State<NotificationsTile> createState() => _NotificationsTileState();
}

class _NotificationsTileState extends State<NotificationsTile> {
  NotificationAccess? _access;
  late final AppLifecycleListener _lifecycle;

  Future<NotificationAccess> _read() =>
      (widget.readAccess ?? NotificationService().access)();

  Future<NotificationAccess> _request() =>
      (widget.requestAccess ?? NotificationService().requestAccess)();

  Future<void> _openSettings() async {
    if (widget.openSettings != null) return widget.openSettings!();
    await openAppSettings();
  }

  // Saves this phone's token in case it never was (it is also saved on the
  // home screen, but a phone denied at first launch may have skipped it).
  Future<void> _turnedOn() async {
    if (widget.onTurnedOn != null) return widget.onTurnedOn!();
    await UserRepository().addUserToken().catchError((_) {});
  }

  @override
  void initState() {
    super.initState();
    _refresh();
    // Coming back from the phone's settings: show what was chosen there.
    _lifecycle = AppLifecycleListener(onResume: _refresh);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    final access = await _read().catchError((_) => NotificationAccess.off);
    if (mounted) setState(() => _access = access);
  }

  Future<void> _onTap() async {
    if (_access == NotificationAccess.on) {
      final open = await showConfirmationDialog(
        context,
        title: 'Notifications are on',
        content: contentText(AppStrings.notificationsOnHelp),
        yes: 'Open Settings',
        no: 'Close',
      );
      if (open == true) await _openSettings();
      return;
    }

    // Android allows its prompt once more after a first "Don't allow", and
    // iOS shows it if it never has. When neither applies this returns at
    // once without showing anything.
    final access = await _request().catchError((_) => NotificationAccess.off);
    if (!mounted) return;
    setState(() => _access = access);

    if (access == NotificationAccess.on) {
      await _turnedOn();
      if (mounted) {
        showSnackbar(AppStrings.notificationsTurnedOn, context,
            snackBarType: SnackbarType.success);
      }
      return;
    }

    final open = await showConfirmationDialog(
      context,
      title: 'Turn on notifications',
      content: contentText(AppStrings.notificationsOffHelp),
      yes: 'Open Settings',
      no: 'Not now',
    );
    if (open == true) await _openSettings();
  }

  @override
  Widget build(BuildContext context) {
    final isOff = _access != null && _access != NotificationAccess.on;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppDivider(),
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PreferenceTile(
                text: 'Notifications',
                trailing: _access?.label,
                onTap: _access == null ? null : _onTap,
                showDivider: false,
              ),
              if (isOff)
                Padding(
                  padding: EdgeInsets.only(bottom: 12.r),
                  child: Text(
                    AppStrings.notificationsOffHint,
                    style: TextStyles.hintText,
                  ),
                ),
            ],
          ),
        ),
        const AppDivider(),
      ],
    );
  }
}
