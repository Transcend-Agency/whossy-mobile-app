import 'package:flutter/material.dart';

import '../../../constants/index.dart';

class ProfileShade extends StatelessWidget {
  const ProfileShade({super.key, required this.heightFactor, this.gradient});

  final double heightFactor;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
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
