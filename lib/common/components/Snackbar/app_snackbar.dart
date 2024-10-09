import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../styles/component_style.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class AppSnackbar extends StatelessWidget {
  const AppSnackbar({
    super.key,
    required this.text,
    this.label,
    this.onLabelTapped,
    this.onClosed,
  });

  final String text;
  final String? label;
  final VoidCallback? onLabelTapped;
  final VoidCallback? onClosed;

  @override
  Widget build(BuildContext context) {
    final width = ScreenUtil().screenWidth;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.symmetric(vertical: label != null ? 8 : 10),
          decoration: snackbarDecoration,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: label == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    alert(),
                    addWidth(10),
                    SizedBox(
                      width: label == null ? width * 0.73 : width * 0.58,
                      child: Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyles.snackBarText,
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
                if (label != null)
                  GestureDetector(
                    onTap: onLabelTapped,
                    child: Container(
                      margin: verifyTouchable,
                      child: Text(
                        label!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyles.snackBarText.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

showSnackbar(String message, BuildContext context) {
  showTopSnackBar(
    Overlay.of(context),
    displayDuration: const Duration(seconds: 5),
    AppSnackbar(
      text: message,
      label: 'Settings',
      onLabelTapped: openAppSettings,
    ),
  );
}
