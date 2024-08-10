import 'dart:isolate';
import 'dart:ui';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CrashlyticsService {
  Future<void> init() async {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = (FlutterErrorDetails details) =>
        FirebaseCrashlytics.instance.recordFlutterFatalError(details);

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    // Add Isolate error listener for Crashlytics
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
      await FirebaseCrashlytics.instance.recordError(
        errorAndStacktrace.first,
        errorAndStacktrace.last,
        fatal: true,
      );
    }).sendPort);
  }
}
