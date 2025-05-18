import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/constants/strings.dart';
import 'package:whossy_app/feature/home/edit_profile/data/state/edit_profile_notifier.dart';

import '../common/utils/services/iap/purchase_handler.dart';
import '../common/utils/services/services.dart';
import '../common/utils/utils.dart';

class Whossy extends StatefulWidget {
  const Whossy({super.key});

  @override
  State<Whossy> createState() => _WhossyState();
}

class _WhossyState extends State<Whossy> with WidgetsBindingObserver {
  late UserPresenceService _userService;
  bool _isInBackground = false;

  @override
  void initState() {
    super.initState();

    _userService = UserPresenceService();
    _userService.trackUserPresence();

    _initIAP();

    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _initIAP() async {
    IAPService.instance.configure(
      handler: AppPurchaseHandler(
        context.read<EditProfileNotifier>(),
      ),
    );

    await IAPService.instance.initialize();
  }

  @override
  void dispose() {
    // Cancel purchase stream to avoid memory leaks
    IAPService.instance.dispose();

    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        // The app is now in the foreground.
        _isInBackground = false;
        _userService.updateUserStatus(true);
        break;
      default:
        // The app is now in a background state or closed.
        if (!_isInBackground) {
          _isInBackground = true;
          _userService.updateUserStatus(false);
        }

        break;
    }
  }

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme().theme(),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
