import 'package:flutter/material.dart';

import '../../../common/components/index.dart';
import '../../../common/utils/index.dart';

class PictureScreen extends StatelessWidget {
  const PictureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Share a snapshot of you",
          subtitle: "Add at least 2 recent photos of yourself 🤗",
        ),
        addHeight(8),
        const Spacer(),
      ],
    );
  }
}
