import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../../../constants/index.dart';

class VerifyPhoto extends StatelessWidget {
  const VerifyPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        addHeight(20),
        Row(
          children: [
            SizedBox.square(
              dimension: 85.r,
              child: Image.asset(AppAssets.verifiedTick),
            ),
          ],
        ),
        addHeight(10),
        const OnboardingHeaderText(
          title: "Get photo verified",
          subtitle:
              'To confirm you’re who you, we’d like to do a photo verification to confirm you’re the person in your photos.',
        ),
        const Spacer(),
      ],
    );
  }
}
