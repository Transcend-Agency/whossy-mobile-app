import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/text_style.dart';
import '../../utils/index.dart';

class DiscardDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? yes;
  final String? no;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DiscardDialog({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
    this.yes,
    this.no,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title,
              style: TextStyles.boldPrefText.copyWith(
                fontSize: AppUtils.scale(14.sp) ?? 16.sp,
              ),
            ),
            addHeight(16),
            Text(content, style: TextStyles.prefText),
            addHeight(20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Text(no ?? 'No', style: TextStyles.prefText),
                  ),
                ),
                addWidth(2),
                GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                    child: Text(
                      yes ?? 'Yes',
                      style: TextStyles.prefText.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool?> showConfirmationDialog(
  BuildContext context, {
  required String title,
  required String content,
  String? yes,
  String? no,
}) {
  return showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return DiscardDialog(
        title: title,
        content: content,
        onConfirm: () => Navigator.pop(context, true),
        onCancel: () => Navigator.pop(context, false),
        yes: yes,
        no: no,
      );
    },
  );
}
