import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/common/components/Text/onboarding_header_text.dart';

import '../../../common/utils/index.dart';

class MeetScreen extends StatelessWidget {
  const MeetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Who do you want to meet ?",
          subtitle:
              'This allows us to suggest the right people for you. You can always change this later.',
        ),
        addHeight(8),
        const Spacer(),
      ],
    );
  }
}
