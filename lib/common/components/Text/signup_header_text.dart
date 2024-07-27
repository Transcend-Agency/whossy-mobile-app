import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/text_style.dart';
import '../../utils/index.dart';

class SignupHeaderText extends StatelessWidget {
  final String title;
  final String subtitle;
  final double top;
  final double bottom;
  final double mid;

  const SignupHeaderText({
    super.key,
    required this.title,
    required this.subtitle,
    this.top = 24,
    this.bottom = 24,
    this.mid = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        addHeight(top),
        Text(
          title,
          style: TextStyles.title.copyWith(fontSize: 24.sp),
        ),
        addHeight(mid),
        Text(
          subtitle,
          style: TextStyles.bioText.copyWith(
            fontSize: AppUtils.scale(11.5.sp),
          ),
        ),
        addHeight(bottom),
      ],
    );
  }
}
