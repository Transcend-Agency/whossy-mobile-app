import 'package:flutter/material.dart';

import '../../../common/components/index.dart';
import '../../../common/utils/index.dart';

class AgeScreen extends StatelessWidget {
  const AgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "How old are you?",
          subtitle:
              'Your age will be displayed alongside your profile excluding your birth date and month.',
        ),
        addHeight(8),
        const Spacer(),
      ],
    );
  }
}