import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';
import 'package:whossy_mobile_app/feature/home/data/state/user_notifier.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';

class InterestBioComponent extends StatefulWidget {
  const InterestBioComponent({super.key});

  @override
  State<InterestBioComponent> createState() => _InterestBioComponentState();
}

class _InterestBioComponentState extends State<InterestBioComponent> {
  late UserNotifier _userNotifier;
  late List<String>? _interests;
  bool similarInterest = true;
  bool hasBio = false;

  @override
  void initState() {
    _userNotifier = Provider.of<UserNotifier>(context, listen: false);

    _interests = _userNotifier.otherPreferences.interests;
    super.initState();
  }

  void updateInterest(bool newValue) {
    setState(() => similarInterest = newValue);

    _userNotifier.updatePreferences(similarInterest: newValue);
  }

  void updatePersonalized() async {
    if (!mounted) return;

    _interests = await context.router
            .push<List<String>>(InterestRoute(initialValues: _interests)) ??
        _interests;

    _userNotifier.updatePreferences(interests: _interests);
  }

  void updateBio(bool newValue) {
    setState(() => hasBio = newValue);

    _userNotifier.updatePreferences(hasBio: newValue);
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
                  Transform.scale(
                    scale: 0.7,
                    child: Switch.adaptive(
                      value: similarInterest,
                      onChanged: updateInterest,
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
                      margin: const EdgeInsets.all(10),
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
                  Transform.scale(
                    scale: 0.7,
                    child: Switch.adaptive(
                      value: hasBio,
                      onChanged: updateBio,
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
