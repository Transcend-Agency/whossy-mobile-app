import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';

import '../../../common/components/index.dart';

class RelPrefScreen extends StatelessWidget {
  const RelPrefScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Specify your relationship preference",
          subtitle:
              'Everyone has a choice, feel free to choose. You can can always change later.',
        ),
        addHeight(8),
        const Spacer(),
      ],
    );
  }
}
