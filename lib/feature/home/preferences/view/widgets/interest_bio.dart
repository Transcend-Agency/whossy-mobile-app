import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/app_utils.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/preferences/data/state/preferences_notifier.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';

class InterestBioComponent extends StatefulWidget {
  const InterestBioComponent({super.key});

  @override
  State<InterestBioComponent> createState() => _InterestBioComponentState();
}

class _InterestBioComponentState extends State<InterestBioComponent> {
  late PreferencesNotifier _prefsNotifier;
  late List<String>? _interests;
  late bool _similarInterest;
  late bool _hasBio;

  @override
  void initState() {
    _prefsNotifier = Provider.of<PreferencesNotifier>(context, listen: false);

    _interests = _prefsNotifier.otherPreferences?.interests;

    _similarInterest = _prefsNotifier.otherPreferences?.similarInterest ?? true;

    _hasBio = _prefsNotifier.otherPreferences?.hasBio ?? false;

    super.initState();
  }

  void updateInterest(bool newValue) {
    setState(() => _similarInterest = newValue);

    _prefsNotifier.updatePreferences(similarInterest: newValue);
  }

  void updatePersonalized() async {
    if (!mounted) return;

    _interests = await context.router
            .push<List<String>>(InterestRoute(initialValues: _interests)) ??
        _interests;

    _prefsNotifier.updatePreferences(interests: _interests);
  }

  void updateBio(bool newValue) {
    setState(() => _hasBio = newValue);

    _prefsNotifier.updatePreferences(hasBio: newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: EdgeInsets.symmetric(horizontal: 14.r),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Have similar interest',
                    style: TextStyles.prefText,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: AppUtils.scale(3) ?? 2),
                    child: Transform.scale(
                      scale: 0.7,
                      child: Switch.adaptive(
                        value: _similarInterest,
                        onChanged: updateInterest,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: AppColors.outlinedColor,
                height: 0,
              ),
              InkWell(
                onTap: updatePersonalized,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add personalized interests',
                      style: TextStyles.prefText,
                    ),
                    Container(
                      margin: EdgeInsets.all(12.r),
                      child: const Icon(
                        Icons.add_circle_rounded,
                        color: Colors.black,
                        size: 26,
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                color: AppColors.outlinedColor,
                height: 0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Has a bio',
                    style: TextStyles.prefText,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: AppUtils.scale(3) ?? 2),
                    child: Transform.scale(
                      scale: 0.7,
                      child: Switch.adaptive(
                        value: _hasBio,
                        onChanged: updateBio,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
      ],
    );
  }
}
