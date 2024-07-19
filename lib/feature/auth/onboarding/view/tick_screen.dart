import 'package:flutter/material.dart';

import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';

class TickScreen extends StatelessWidget {
  final int pageIndex;
  const TickScreen({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "What makes you tick?",
          subtitle: 'Share the interests and habits that define you.',
          skip: true,
        ),
        addHeight(8),
        const Spacer(),
      ],
    );
  }
}
