import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';

import '../../../common/components/index.dart';
import '../../../constants/index.dart';

class RelPrefScreen extends StatefulWidget {
  final void Function(Preference? selectedPreference) onPreferenceSelected;

  const RelPrefScreen({
    super.key,
    required this.onPreferenceSelected,
  });

  @override
  State<RelPrefScreen> createState() => _RelPrefScreenState();
}

class _RelPrefScreenState extends State<RelPrefScreen> {
  Preference? _pref;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            return RadioTile(
              leadingAsset: data.leadingAsset,
              value: data.value,
              groupValue: _pref,
              onChanged: (value) {
                setState(() {
                  _pref = value;
                });
                widget.onPreferenceSelected(value); // Notify Wrapper
              },
              title: data.title,
              subtitle: data.subtitle,
            );
          }).toList(),
        ),
        const Spacer(),
      ],
    );
  }
}
