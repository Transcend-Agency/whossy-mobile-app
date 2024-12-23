import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class LifecycleEventHandler extends WidgetsBindingObserver {
  final Future<void> Function() onResume;

  LifecycleEventHandler({required this.onResume});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume();
    }
  }
}

Stream<LocationPermission> createLifecycleAwarePermissionStream() {
  final controller = StreamController<LocationPermission>();

  Future<void> emitPermissionStatus() async {
    try {
      final permission = await Geolocator.checkPermission();
      controller.add(permission);
    } catch (e) {
      controller.addError(e);
    }
  }

  emitPermissionStatus();

  // Observe app lifecycle and emit permission status when app is resumed
  WidgetsBinding.instance.addObserver(
    LifecycleEventHandler(
      onResume: emitPermissionStatus,
    ),
  );

  // Listen for changes in the service status (e.g., GPS being enabled/disabled)
  Geolocator.getServiceStatusStream().listen((status) async {
    if (status == ServiceStatus.enabled) {
      emitPermissionStatus();
    } else {
      controller.add(LocationPermission.denied);
    }
  });

  return controller.stream;
}
