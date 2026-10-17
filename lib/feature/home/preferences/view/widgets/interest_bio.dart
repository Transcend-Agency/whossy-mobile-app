import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';
import 'package:whossy_app/feature/home/preferences/model/other_preferences.dart';

import '../../../../../common/components/components.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/provider.dart';

class InterestBioComponent<T extends SearchPreferencesNotifier>
    extends HookWidget {
  const InterestBioComponent({super.key});

  Future<void> updatePersonalized(
    BuildContext context,
    T notifier,
    List<String> interests,
  ) async {
    if (!context.mounted) return;

    List<String> newInterests = await context.router.push<List<String>>(
          InterestRoute(initialValues: interests),
        ) ??
        interests;

    notifier.updatePreferences(interests: newInterests);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<T>();

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
                                padding: EdgeInsets.symmetric(vertical: 15.r)
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
                                    value: prefs.similarInterest ?? true,
                                    onChanged: (value) =>
                                        notifier.updatePreferences(
                                            similarInterest: value),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  const AppDivider(),
                  InkWell(
                    onTap: () => updatePersonalized(
                      context,
                      notifier,
                      prefs?.interests ?? [],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 13.r),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Add personalized interests',
                            style: TextStyles.prefText,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                prefs?.interests.getSelectionStatus() ??
                                    'Choose',
                                style: (TextStyles.prefText).copyWith(
                                  color: AppColors.hintTextColor,
                                ),
                              ),
                              addWidth(6),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                color: AppColors.hintTextColor,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
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
                                padding: EdgeInsets.symmetric(vertical: 15.r)
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
                                    value: prefs.hasBio ?? false,
                                    onChanged: (value) => notifier
                                        .updatePreferences(hasBio: value),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        const AppDivider(),
      ],
    );
  }
}
