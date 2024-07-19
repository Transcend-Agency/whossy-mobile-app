import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../view_model/onboarding_provider.dart';

class SmokerScreen extends StatefulWidget {
  final int pageIndex;

  const SmokerScreen({super.key, required this.pageIndex});

  @override
  State<SmokerScreen> createState() => _SmokerScreenState();
}

class _SmokerScreenState extends State<SmokerScreen>
    with AutomaticKeepAliveClientMixin<SmokerScreen> {
  Smoke? _smoke;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Are you a smoker?",
          subtitle: 'This will be shown on your profile',
          skip: true,
        ),
        addHeight(24),
        ListView(
          shrinkWrap: true,
          children: AppConstants.smokeData.map((data) {
            return GenericTile(
              value: data.value,
              groupValue: _smoke,
              onChanged: (value) {
                setState(() => _smoke = value);
                context.read<OnboardingProvider>().select(widget.pageIndex);
              },
              title: data.text,
            );
          }).toList(),
        ),
        const Spacer(),
      ],
    );
  }
}
