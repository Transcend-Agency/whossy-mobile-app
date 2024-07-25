import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/view_model/onboarding_provider.dart';

import '../../../../common/components/index.dart';
import '../../../../constants/index.dart';

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
        GestureDetector(
          onTap: () => log('The preference value is $_pref'),
          child: const OnboardingHeaderText(
            title: "Specify your relationship preference",
            subtitle:
                'Everyone has a choice, feel free to choose. You can can always change later.',
          ),
        ),
        addHeight(24),
        ListView(
          shrinkWrap: true,
          children: AppConstants.preferenceData.map((data) {
            return Consumer<OnboardingProvider>(
              builder: (_, onboarding, __) {
                return RadioTile(
                  leadingAsset: data.leadingAsset,
                  value: data.value,
                  groupValue: _pref,
                  onChanged: (_) {
                    setState(() => _pref = _);
                    onboarding.select(widget.pageIndex);
                    onboarding.updateUserProfile(relationshipPref: _.name);
                  },
                  title: data.title,
                  subtitle: data.subtitle,
                );
              },
            );
          }).toList(),
        ),
        const Spacer(),
      ],
    );
  }
}
