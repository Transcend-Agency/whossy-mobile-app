import 'package:flutter/material.dart';

import '../../../common/components/index.dart';
import '../../../common/utils/index.dart';

class DistanceScreen extends StatelessWidget {
  const DistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Distance search radius",
          subtitle:
              'Use the slider below to set a radius of how far you want our system to search for matches within your current location. You can always change this later in the settings.',
        ),
        addHeight(8),
        const Spacer(),
      ],
    );
  }
}
