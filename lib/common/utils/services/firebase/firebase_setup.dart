import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kDebugMode;

import '../../../../firebase_options.dart';

/// Starts Firebase and App Check. Used by the app at launch and by the
/// background push handler, which runs in its own isolate and has to set
/// both up again before it can reach Firestore.
Future<void> initFirebase() async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

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
}
