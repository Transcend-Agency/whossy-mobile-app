import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../constants/index.dart';
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
    this.snackbarType = SnackbarType.error,
  });

  final String text;
  final String? label;
  final VoidCallback? onLabelTapped;
  final VoidCallback? onClosed;
  final SnackbarType snackbarType;

  @override
  Widget build(BuildContext context) {
    final width = ScreenUtil().screenWidth;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.symmetric(vertical: label != null ? 8 : 10),
          decoration: BoxDecoration(
            color: AppColors.sbFillColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              width: 1,
              color: snackbarType.color,
            ),
          ),
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
                    Icon(
                      snackbarType.icon,
                      color: snackbarType.color,
                      size: 24,
                    ),
                    addWidth(10),
                    SizedBox(
                      width: label == null ? width * 0.73 : width * 0.58,
                      child: Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyles.snackBarText
                            .copyWith(color: snackbarType.color),
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
                          color: snackbarType.color,
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

showSnackbar(
  String message,
  BuildContext context, {
  SnackbarType snackBarType = SnackbarType.error,
  String? label,
  int durationInSec = 3,
}) {
  if (context.mounted) {
    showTopSnackBar(
      Overlay.of(context),
      displayDuration: Duration(seconds: durationInSec),
      AppSnackbar(
        text: message,
        label: label,
        onLabelTapped: label != null ? openAppSettings : null,
        snackbarType: snackBarType,
      ),
    );
  }
}

enum SnackbarType {
  error(AppColors.sbErrorBorderColor, Icons.error_outline_outlined),
  warning(Colors.orange, Icons.warning_amber_rounded),
  success(Colors.green, Icons.check_circle_outline);

  const SnackbarType(this.color, this.icon);

  final Color color;
  final IconData icon;
}
