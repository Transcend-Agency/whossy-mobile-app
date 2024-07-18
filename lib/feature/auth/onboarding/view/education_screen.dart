import 'package:flutter/material.dart';

import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Is education your thing?",
          subtitle: 'This will be shown on your profile',
        ),
        addHeight(8),
        const Spacer(),
      ],
    );
  }
}
