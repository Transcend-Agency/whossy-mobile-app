import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/constants/strings.dart';

import '../common/utils/router/routes.dart';
import '../common/utils/theme/theme.dart';

class Whossy extends StatelessWidget {
  const Whossy({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppTheme().appTheme(),
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
