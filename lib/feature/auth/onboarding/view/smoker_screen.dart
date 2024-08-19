import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';
import '../data/source/smoke_data.dart';
import '../data/state/onboarding_notifier.dart';

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
        Consumer<OnboardingNotifier>(
          builder: (_, onboarding, __) {
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: smokeData.map((data) {
                return GenericTile(
                  value: data.value,
                  groupValue: _smoke,
                  onChanged: (_) {
                    setState(() => _smoke = _);
                    onboarding.select(widget.pageIndex);
                    onboarding.updateUserProfile(smoker: _?.index);
                  },
                  title: data.text,
                );
              }).toList(),
            );
          },
        ),
        const Spacer(),
      ],
    );
  }
}
