import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/app/whossy.dart';
import 'package:whossy_app/provider/app_providers.dart';

import 'common/utils/services/services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // App Check attestation. Play Integrity / App Attest only succeed on real,
  // store-recognized builds — on emulators and debug builds they fail with
  // "App attestation failed" (403), and once App Check is enforced (or rate-
  // limited: "Too many attempts") that blocks every Firestore/Storage call,
  // making the app look like it can't get past login.
  //
  // So in debug builds use the debug provider instead. It prints an App Check
  // debug token to the console on first run; register that token in Firebase
  // Console → App Check → (this app) → Manage debug tokens to allow the
  // device. Release builds keep the real attestation providers.
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.appAttest,
  );

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
