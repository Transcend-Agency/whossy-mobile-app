import 'package:flutter/material.dart';

import '../../../common/components/index.dart';
import '../../../common/utils/index.dart';

class SmokerScreen extends StatelessWidget {
  const SmokerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Are you a smoker?",
          subtitle: 'This will be shown on your profile',
        ),
        addHeight(8),
        const Spacer(),
      ],
    );
  }
}
