import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/index.dart';
import '../../../../common/utils/index.dart';
import '../data/source/preference_data.dart';
import '../data/state/onboarding_notifier.dart';

class RelPrefScreen extends StatefulWidget {
  final int pageIndex;

  const RelPrefScreen({
    super.key,
    required this.pageIndex,
  });

  @override
  State<RelPrefScreen> createState() => _RelPrefScreenState();
}

class _RelPrefScreenState extends State<RelPrefScreen>
    with AutomaticKeepAliveClientMixin<RelPrefScreen> {
  Preference? _pref;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Specify your relationship preference",
          subtitle:
              'Everyone has a choice, feel free to choose. You can can always change later.',
        ),
        addHeight(24),
        Consumer<OnboardingNotifier>(
          builder: (_, onboarding, __) {
            return ListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: preferenceData.map((data) {
                return RadioTile(
                  leadingAsset: data.leadingAsset,
                  value: data.value,
                  groupValue: _pref,
                  onChanged: (_) {
                    setState(() => _pref = _);
                    onboarding.select(widget.pageIndex);
                    onboarding.updateUserProfile(relationshipPref: _?.index);
                  },
                  title: data.title,
                  subtitle: data.subtitle,
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
