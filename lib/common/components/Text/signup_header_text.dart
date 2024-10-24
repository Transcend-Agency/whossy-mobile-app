import 'package:flutter/material.dart';

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
    this.top = 40,
    this.bottom = 24,
    this.mid = 8,
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
            fontSize: AppUtils.scale(32) ?? 26,
          ),
        ),
        addHeight(mid),
        Text(
          subtitle,
          textAlign: center ? TextAlign.center : null,
          style: TextStyles.bioText.copyWith(
            fontSize: AppUtils.scale(17) ?? 15,
          ),
        ),
        addHeight(bottom),
      ],
    );
  }
}
