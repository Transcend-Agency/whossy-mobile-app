import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/utils/services/user_service.dart';
import 'package:whossy_app/constants/strings.dart';

import '../common/utils/index.dart';

class Whossy extends StatefulWidget {
  const Whossy({super.key});

  @override
  State<Whossy> createState() => _WhossyState();
}

class _WhossyState extends State<Whossy> with WidgetsBindingObserver {
  late UserService _userService;
  bool _isInBackground = false; // Track background state

  @override
  void initState() {
    super.initState();

    _userService = UserService();
    _userService.trackUserPresence();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
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
