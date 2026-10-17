import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectivityNotifier with ChangeNotifier {
  late StreamSubscription _subscription;
  bool _isConnected = false;

  bool get isConnected => _isConnected;

  ConnectivityNotifier() {
    _subscription = Connectivity().onConnectivityChanged.listen((_) async {
      _isConnected = await InternetConnectionChecker().hasConnection;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
