import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';

class PrivacyText extends StatelessWidget {
  const PrivacyText({
    super.key,
    required this.action,
    required this.text,
  });

  final VoidCallback action;
  final String text;

  // Todo: Make responsive for smaller screens
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, right: 8.w, left: 8.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            color: AppColors.black,
          ),
          children: [
            TextSpan(
              text: text,
              style: TextStyles.fieldHeader,
            ),
            TextSpan(
              text: AppStrings.termsAndConditions,
              style: TextStyles.privacyText,
              recognizer: TapGestureRecognizer()..onTap = action,
            ),
            TextSpan(
              text: AppStrings.dataProcessingInfo,
              style: TextStyles.fieldHeader,
            ),
            TextSpan(
              text: AppStrings.privacyPolicy,
              style: TextStyles.privacyText,
              recognizer: TapGestureRecognizer()..onTap = action,
            ),
          ], //
        ),
      ),
    );
  }
}
