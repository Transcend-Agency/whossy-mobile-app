import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/view_model/auth_provider.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';

class PrivacyText extends StatelessWidget {
  const PrivacyText({
    super.key,
    required this.auth,
    required this.text,
  });

  final AuthenticationProvider auth;
  final String text;

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
              style: TextStyles.underlineText,
              recognizer: TapGestureRecognizer()..onTap = auth.launchTC,
            ),
            TextSpan(
              text: AppStrings.dataProcessingInfo,
              style: TextStyles.fieldHeader,
            ),
            TextSpan(
              text: AppStrings.privacyPolicy,
              style: TextStyles.underlineText,
              recognizer: TapGestureRecognizer()..onTap = auth.launchTC,
            ),
          ], //
        ),
      ),
    );
  }
}
