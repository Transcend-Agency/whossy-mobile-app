import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestPhotoPermission() async {
    var status = await Permission.photos.status;

    // Log the permission status
    log('Permission status after error: $status');

    if (status.isDenied || status.isRestricted) {
      var newStatus = await Permission.photos.request();

      log('New permission status: $newStatus');
      return newStatus.isGranted;
    }
    return status.isGranted;
  }

  static Future<void> handlePermanentlyDeniedPermission({
    required BuildContext context,
    required Function(BuildContext context) showDialog,
  }) async {
    var result = await showDialog(context);
    if (result == true) {
      openAppSettings();
    }
  }
}
