import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whossy_app/common/utils/app_utils.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';

class PrivacyText extends StatelessWidget {
  const PrivacyText({
    super.key,
    required this.text,
  });

  final String text;

  void _launchURL(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, right: 8.w, left: 8.w),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: text,
              style: TextStyles.fieldHeader.copyWith(
                fontSize: AppUtils.scale(16),
              ),
            ),
            TextSpan(
              text: AppStrings.termsAndConditions,
              style: TextStyles.privacyText.copyWith(
                fontSize: AppUtils.scale(16),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _launchURL(AppStrings.termsUrl),
            ),
            TextSpan(
              text: AppStrings.dataProcessingInfo,
              style: TextStyles.fieldHeader.copyWith(
                fontSize: AppUtils.scale(16),
              ),
            ),
            TextSpan(
              text: AppStrings.privacyPolicy,
              style: TextStyles.privacyText.copyWith(
                fontSize: AppUtils.scale(16),
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => _launchURL(AppStrings.privacyUrl),
            ),
          ], //
        ),
      ),
    );
  }
}
