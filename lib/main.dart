import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/app/whossy.dart';
import 'package:whossy_mobile_app/provider/providers.dart';

import 'common/utils/services/services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Todo: (Prod) Test this in a production-enabled environment
  // Getting the error
  // E/FirebaseAuth(26281): [SmsRetrieverHelper] SMS verification code request failed:
  // unknown status code: 18002 Invalid PlayIntegrity token; app not Recognized by Play Store.
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
  );

  // Start up necessary services
  await CrashlyticsService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingNotifier()),
        ChangeNotifierProvider(create: (_) => SignUpNotifier()),
        ChangeNotifierProvider(create: (_) => LoginNotifier()),
        ChangeNotifierProvider(create: (_) => PreferencesNotifier()),
      ],
      child: Whossy(),
    ),
  );
}
