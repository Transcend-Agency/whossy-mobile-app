import 'package:flutter/material.dart';

import '../../../common/components/index.dart';
import '../../../common/utils/index.dart';

class TickScreen extends StatelessWidget {
  const TickScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "What makes you tick?",
          subtitle: 'Share the interests and habits that define you.',
        ),
        addHeight(8),
        const Spacer(),
      ],
    );
  }
}
