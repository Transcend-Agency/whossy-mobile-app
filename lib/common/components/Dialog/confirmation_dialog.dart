import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String? yes;
  final String? no;
  final String? headerImage;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
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
        padding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (headerImage != null)
              Image.asset(
                headerImage!,
                height: 110,
              ),
            Text(
              title,
              style: TextStyles.title.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            addHeight(10),
            Text(
              content,
              style: TextStyles.bioText.copyWith(
                fontSize: AppUtils.scale(11.5.sp),
              ),
              textAlign: TextAlign.center,
            ),
            addHeight(16),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: MaterialButton(
                    color: AppColors.buttonColor,
                    textColor: Colors.white,
                    elevation: 0,
                    shape: circularBorder,
                    onPressed: onConfirm,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Text(
                      yes ?? 'Yes',
                      style: TextStyles.buttonText.copyWith(
                        fontSize: AppUtils.scale(18),
                      ),
                    ),
                  ),
                ),
                addWidth(8),
                Expanded(
                  child: MaterialButton(
                    color: AppColors.listTileColor,
                    textColor: AppColors.hintTextColor,
                    elevation: 0,
                    shape: circularBorder,
                    onPressed: onCancel,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Text(
                      no ?? 'No',
                      style: TextStyles.buttonText.copyWith(
                        fontSize: AppUtils.scale(18),
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
  String? headerImage,
  String? yes,
  String? no,
}) {
  return showDialog<bool?>(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(
        title: title,
        content: content,
        onConfirm: () => Navigator.pop(context, true),
        onCancel: () => Navigator.pop(context, false),
        yes: yes,
        no: no,
        headerImage: headerImage,
      );
    },
  );
}
