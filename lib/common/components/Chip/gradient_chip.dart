import 'package:flutter/material.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';

class GradientChip extends StatelessWidget {
  const GradientChip({
    super.key,
    required this.text,
    required this.width,
    required this.height,
  });

  final String text;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform(
          transform: Matrix4.skewX(-.3),
          alignment: Alignment.center,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: AppColors.splashGradient,
            ),
          ),
        ),
        Text(
          text,
          style: TextStyles.boldPrefText.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
