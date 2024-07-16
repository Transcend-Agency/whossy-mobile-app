import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/strings.dart';
import '../../styles/text_style.dart';
import '../../utils/app_utils.dart';

class GradientText extends StatelessWidget {
  final Gradient gradient;

  const GradientText({
    super.key,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (_) => gradient.createShader(_),
      child: RichText(
        text: TextSpan(
          style: TextStyles.header.copyWith(fontSize: AppUtils.scale(43.sp)),
          children: const [
            TextSpan(text: AppStrings.splashText1),
            TextSpan(text: AppStrings.splashText2),
          ],
        ),
        textScaler: const TextScaler.linear(0.95),
      ),
    );
  }
}
