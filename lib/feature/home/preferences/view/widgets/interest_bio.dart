import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/app_utils.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/preferences/model/other_preferences.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';

class InterestBioComponent<T extends SearchPreferencesNotifier>
    extends StatefulWidget {
  const InterestBioComponent({super.key});

  @override
  State<InterestBioComponent<T>> createState() => _InterestBioComponentState();
}

class _InterestBioComponentState<T extends SearchPreferencesNotifier>
    extends State<InterestBioComponent<T>> {
  late T _notifier;

  late bool _hasBio;
  late bool _similarInterest;
  late List<String>? _interests;

  bool _hasUpdatedSimilarInterest = false;
  bool _hasUpdatedPersonalizedInterest = false;
  bool _hasUpdatedBio = false;

  @override
  void initState() {
    _notifier = context.read<T>();

    super.initState();
  }

  void updateInterest(bool newValue) {
    setState(() => _similarInterest = newValue);

    _notifier.updatePreferences(similarInterest: newValue);
  }

  void updatePersonalized() async {
    if (!mounted) return;

    _interests = await context.router
            .push<List<String>>(InterestRoute(initialValues: _interests)) ??
        _interests;

    _notifier.updatePreferences(interests: _interests);
  }

  void updateBio(bool newValue) {
    setState(() => _hasBio = newValue);

    _notifier.updatePreferences(hasBio: newValue);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppDivider(),
        Container(
            decoration: const BoxDecoration(color: AppColors.inputBackGround),
            padding: EdgeInsets.symmetric(horizontal: 14.r),
            child: Selector<T, OtherPreferences?>(
              selector: (_, notifier) => notifier.otherPreferences,
              builder: (_, prefs, __) {
                if (prefs != null) {
                  if (!_hasUpdatedSimilarInterest) {
                    _similarInterest = prefs.similarInterest ?? true;

                    _hasUpdatedSimilarInterest = true;
                  }

                  if (!_hasUpdatedPersonalizedInterest) {
                    _interests = prefs.interests ?? [];

                    _hasUpdatedPersonalizedInterest = true;
                  }

                  if (!_hasUpdatedBio) {
                    _hasBio = prefs.hasBio ?? false;

                    _hasUpdatedBio = true;
                  }
                }
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Have similar interest',
                          style: TextStyles.prefText,
                        ),
                        AppAnimatedSwitcher(
                          child: prefs == null
                              ? Padding(
                                  key: const ValueKey(false),
                                  padding: EdgeInsets.symmetric(vertical: 15.h)
                                      .copyWith(right: 11.w),
                                  child: const ShimmerSwitch(),
                                )
                              : Padding(
                                  key: const ValueKey("data"),
                                  padding: EdgeInsets.symmetric(
                                      vertical: AppUtils.scale(3) ?? 2),
                                  child: Transform.scale(
                                    scale: 0.7,
                                    child: Switch.adaptive(
                                      value: _similarInterest,
                                      onChanged: updateInterest,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const AppDivider(),
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
                    const AppDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Has a bio',
                          style: TextStyles.prefText,
                        ),
                        AppAnimatedSwitcher(
                          child: prefs == null
                              ? Padding(
                                  key: const ValueKey(false),
                                  padding: EdgeInsets.symmetric(vertical: 15.h)
                                      .copyWith(right: 11.w),
                                  child: const ShimmerSwitch(),
                                )
                              : Padding(
                                  key: const ValueKey("data"),
                                  padding: EdgeInsets.symmetric(
                                      vertical: AppUtils.scale(3) ?? 2),
                                  child: Transform.scale(
                                    scale: 0.7,
                                    child: Switch.adaptive(
                                      value: _hasBio,
                                      onChanged: updateBio,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            )),
        const AppDivider(),
      ],
    );
  }
}
