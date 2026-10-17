import 'package:flutter/material.dart';

import '../../../constants/index.dart';

class ProfileShade extends StatelessWidget {
  const ProfileShade({
    super.key,
    required this.heightFactor,
    this.gradient,
    this.alignment = Alignment.bottomCenter,
  });

  final double heightFactor;
  final Gradient? gradient;
  final AlignmentGeometry? alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment!,
      child: FractionallySizedBox(
        heightFactor: heightFactor,
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient ?? AppColors.profileShade,
          ),
        ),
      ),
    );
  }
}
