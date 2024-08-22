import 'package:flutter/material.dart';

import '../../../constants/index.dart';

class ProfileShade extends StatelessWidget {
  const ProfileShade({super.key, required this.heightFactor});

  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: heightFactor,
        child: Container(
          decoration: BoxDecoration(
            gradient: AppColors.profileShade,
          ),
        ),
      ),
    );
  }
}
