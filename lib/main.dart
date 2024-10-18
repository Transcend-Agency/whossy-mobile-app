import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/app/whossy.dart';
import 'package:whossy_app/provider/providers.dart';

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
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.playIntegrity,
  //   appleProvider: AppleProvider.appAttest,
  // );

  // Start up necessary services
  await CrashlyticsService().init();

  await NotificationService().init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OnboardingNotifier()),
        ChangeNotifierProvider(create: (_) => SignUpNotifier()),
        ChangeNotifierProvider(create: (_) => LoginNotifier()),
        ChangeNotifierProvider(create: (_) => PreferencesNotifier()),
        ChangeNotifierProvider(create: (_) => SettingsNotifier()),
        ChangeNotifierProvider(create: (_) => EditProfileNotifier()),
        ChangeNotifierProvider(create: (_) => ConnectivityNotifier()),
        ChangeNotifierProxyProvider2<EditProfileNotifier, ConnectivityNotifier,
            ChatsNotifier>(
          create: (_) => ChatsNotifier(),
          update: (_, profileData, networkStatus, chatNotifier) {
            chatNotifier!.saveProfile(profileData.staticProfile);
            chatNotifier.updateConnectivity(networkStatus.isConnected);
            return chatNotifier;
          },
        ),
        ChangeNotifierProvider(create: (_) => AdvancedSearchNotifier()),
      ],
      child: const Whossy(),
    ),
  );
}
