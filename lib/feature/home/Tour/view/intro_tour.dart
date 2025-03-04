import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../common/styles/component_style.dart';
import '../../../../common/utils/utils.dart';
import '../../../../constants/index.dart';
import '../../../../provider/provider.dart';
import '../../settings/view/widgets/widgets.dart';

final introTourTargets = [
  TargetFocus(
    identify: 'globalSearchTab',
    keyTarget: GlobalKeys.globalSearchTabKey,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        padding: pagePadding.copyWith(bottom: 40.h),
        builder: (context, controller) {
          return TutorialComponent(
            title: 'Explore',
            step: "1 / 5",
            body: AppStrings.globalSearchTabTutorial,
            onSkip: () => controller.skip(),
            onNext: () => controller.next(),
          );
        },
      ),
    ],
  ),
  TargetFocus(
    identify: 'fireTab',
    keyTarget: GlobalKeys.fireTabKey,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        padding: pagePadding.copyWith(bottom: 40.h),
        builder: (context, controller) {
          return TutorialComponent(
            title: 'Swipe and Match',
            step: "2 / 5",
            body: AppStrings.fireTabTutorial,
            onSkip: () => controller.skip(),
            onNext: () => controller.next(),
          );
        },
      ),
    ],
  ),
  TargetFocus(
    identify: 'heartTab',
    keyTarget: GlobalKeys.heartTabKey,
    paddingFocus: 2,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        padding: pagePadding.copyWith(bottom: 40.h),
        builder: (context, controller) {
          return TutorialComponent(
            title: 'Likes and Matches',
            step: "3 / 5",
            body: AppStrings.heartTabTutorial,
            onSkip: () => controller.skip(),
            onNext: () => controller.next(),
          );
        },
      ),
    ],
  ),
  TargetFocus(
    identify: 'chatTab',
    keyTarget: GlobalKeys.chatTabKey,
    paddingFocus: 2,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        padding: pagePadding.copyWith(bottom: 40.h),
        builder: (context, controller) {
          return TutorialComponent(
            title: 'Chats',
            step: "4 / 5",
            body: AppStrings.chatTabTutorial,
            onSkip: () => controller.skip(),
            onNext: () => controller.next(),
          );
        },
      ),
    ],
  ),
  TargetFocus(
    identify: 'userTab',
    keyTarget: GlobalKeys.userTabKey,
    paddingFocus: 2,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        padding: pagePadding.copyWith(bottom: 40.h),
        builder: (context, controller) {
          return TutorialComponent(
            title: 'Profile',
            step: "5 / 5",
            body: AppStrings.userTabTutorial,
            onNext: () => controller.next(),
            next: 'Done',
          );
        },
      ),
    ],
  ),
];

void startIntroTutorial({
  required BuildContext context,
  required SwipeAndMatchNotifier swipeAndMatchNotifier,
}) {
  Future.delayed(
    const Duration(seconds: 5),
    () {
      if (!swipeAndMatchNotifier.hasTakenTutorial) {
        TutorialCoachMark(
          hideSkip: true,
          paddingFocus: 0,
          targets: introTourTargets,
          colorShadow: Colors.black.withOpacity(0.2),
          onFinish: () => swipeAndMatchNotifier.hasTakenTutorial = true,
        ).show(context: context);
      }
    },
  );
}
