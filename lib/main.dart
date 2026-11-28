import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/app/whossy.dart';
import 'package:whossy_app/provider/app_providers.dart';

import 'common/utils/services/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await initFirebase();

  // Start up necessary services
  await CrashlyticsService().init();

  await NotificationService().init();

  runApp(
    MultiProvider(
      providers: appProviders,
      child: const Whossy(),
    ),
  );
}
