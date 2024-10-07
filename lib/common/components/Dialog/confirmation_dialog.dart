import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';
import '../index.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final Widget content; // Changed to accept a Widget
  final String? yes;
  final String? no;
  final Widget? headerImage;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content, // Adjust to the new Widget type
    required this.onConfirm,
    required this.onCancel,
    this.yes,
    this.no,
    this.headerImage,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (headerImage != null) ...[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: headerImage,
              ),
            ],
            Text(
              title,
              style:
                  TextStyles.title.copyWith(fontSize: AppUtils.scale(27) ?? 24),
              textAlign: TextAlign.center,
            ),
            addHeight(12),
            content, // Use the passed widget content
            addHeight(16),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (yes != null)
                  Expanded(
                    child: DialogButton(
                      text: yes ?? 'Yes',
                      color: AppColors.buttonColor,
                      textColor: Colors.white,
                      onPressed: onConfirm,
                    ),
                  ),
                if (yes != null && no != null) addWidth(8),
                if (no != null)
                  Expanded(
                    child: DialogButton(
                      text: no ?? 'No',
                      color: AppColors.listTileColor,
                      textColor: AppColors.hintTextColor,
                      onPressed: onCancel,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  Widget? headerImage,
  String? yes,
  String? no,
}) {
  return showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: title,
        content: content, // Pass the content as a Widget
        onConfirm: () => Navigator.pop(context, true),
        onCancel: () => Navigator.pop(context, false),
        yes: yes,
        no: no,
        headerImage: headerImage,
      );
    },
  );
}
