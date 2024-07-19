import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/styles/text_style.dart';
import '../../../common/utils/index.dart';
import '../../../constants/index.dart';

class OnboardingHeaderText extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool skip;

  const OnboardingHeaderText({
    super.key,
    required this.title,
    required this.subtitle,
    this.skip = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        skip ? addHeight(36) : const SizedBox.shrink(),
        Text(
          title,
          style: TextStyles.title.copyWith(fontSize: 24.sp),
        ),
        addHeight(4),
        Text(
          subtitle,
          style: TextStyles.hintText.copyWith(
            fontSize: AppUtils.scale(11.5.sp),
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
