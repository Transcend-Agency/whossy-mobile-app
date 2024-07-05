import 'dart:math';

import 'package:flutter/material.dart';

class AppUtils {
  /// Global key for accessing the ScaffoldMessengerState to show SnackBars.
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(
    String? text, {
    Duration delay = const Duration(seconds: 2),
    String? label,
    VoidCallback? onLabelTapped,
    VoidCallback? onClosed,
  }) {
    if (text == null) return;

    const snackBar = SnackBar(content: Placeholder());

    // final snackBar = SnackBar(
    //   elevation: 4,
    //   margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
    //   behavior: SnackBarBehavior.floating,
    //   duration: delay,
    //   content: Row(
    //     mainAxisAlignment: label == null
    //         ? MainAxisAlignment.center
    //         : MainAxisAlignment.spaceBetween,
    //     children: [
    //       Flexible(
    //         child: Text(
    //           text,
    //           textAlign: label == null ? TextAlign.center : TextAlign.left,
    //           overflow: TextOverflow.ellipsis,
    //           maxLines: 2,
    //           style: const TextStyle(
    //             color: Colors.black87,
    //             fontSize: 16,
    //           ),
    //         ),
    //       ),
    //       const SizedBox.shrink(),
    //     ],
    //   ),
    //   backgroundColor: AppColors.selectedBackgroundColor,
    //   action: label != null
    //       ? SnackBarAction(
    //     label: label,
    //     textColor: AppColors.primaryColor,
    //
    //     // Call the custom label callback
    //     onPressed: () => onLabelTapped?.call(),
    //   )
    //       : null,
    // );

    messengerKey.currentState!
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar).closed.then((reason) {
        // Check if the snackbar is closed by tapping the label
        if (reason != SnackBarClosedReason.action) {
          onClosed?.call(); // Call the onClosed callback for other reasons
        }
      });
  }

  /// Calculates a text scale factor based on the device width and a maximum scale factor.
  static double textScaleFactor(BuildContext context,
      {double maxTextScaleFactor = 2}) {
    final width = MediaQuery.of(context).size.width;
    double val = (width / 1400) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }
}
