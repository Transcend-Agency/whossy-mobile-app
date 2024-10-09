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
  final bool center;

  const SignupHeaderText({
    super.key,
    required this.title,
    required this.subtitle,
    this.top = 24,
    this.bottom = 24,
    this.mid = 4,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        addHeight(top),
        Text(
          title,
          textAlign: center ? TextAlign.center : null,
          style: TextStyles.title.copyWith(
            fontSize: AppUtils.scale(24.sp) ?? 26,
          ),
        ),
        addHeight(mid),
        Text(
          subtitle,
          textAlign: center ? TextAlign.center : null,
          style: TextStyles.bioText.copyWith(
            fontSize: AppUtils.scale(16) ?? 15,
          ),
        ),
        addHeight(bottom),
      ],
    );
  }
}
