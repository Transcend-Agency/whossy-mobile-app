import 'package:flutter/material.dart';

import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';

class BioScreen extends StatelessWidget {
  final int pageIndex;

  const BioScreen({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Your bio: Let others know who you are :)",
          subtitle: 'A short introduction about who you are',
          skip: true,
        ),
        addHeight(8),
        const Spacer(),
      ],
    );
  }
}
