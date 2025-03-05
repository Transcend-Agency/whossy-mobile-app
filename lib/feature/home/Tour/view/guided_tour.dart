import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../../common/styles/component_style.dart';
import '../../../../common/utils/utils.dart';
import '../../../../constants/index.dart';
import '../../../../provider/provider.dart';
import '../../settings/view/widgets/widgets.dart';

final exploreTutorialTargets = [
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
            // step: "1 / 5",
            body: AppStrings.globalSearchTabTutorial,
            onSkip: () => controller.skip(),
            onNext: () => controller.next(),
          );
        },
      ),
    ],
  ),
  TargetFocus(
    identify: 'notification',
    keyTarget: GlobalKeys.notificationKey,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        padding: pagePadding.copyWith(top: 40.h),
        builder: (context, controller) {
          return TutorialComponent(
            title: 'Notifications',
            // step: "1 / 5",
            body: AppStrings.notificationsTabTutorial,
            onSkip: () => controller.skip(),
            onNext: () => controller.next(),
          );
        },
      ),
    ],
  ),
  TargetFocus(
    identify: 'advancedSearch',
    keyTarget: GlobalKeys.advancedSearchKey,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        padding: pagePadding.copyWith(top: 40.h),
        builder: (context, controller) {
          return TutorialComponent(
            title: 'Advanced Search',
            // step: "1 / 5",
            body: AppStrings.advancedSearchTutorial,
            onSkip: () => controller.skip(),
            onNext: () => controller.next(),
          );
        },
      ),
    ],
  ),
];

final matchingTutorialTargets = [
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
            //step: "2 / 5",
            body: AppStrings.fireTabTutorial,
            onSkip: () => controller.skip(),
            onNext: () => controller.next(),
          );
        },
      ),
    ],
  ),
  TargetFocus(
    identify: 'preferences',
    keyTarget: GlobalKeys.matchingPreferencesKey,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        padding: pagePadding.copyWith(top: 40.h),
        builder: (context, controller) {
          return TutorialComponent(
            title: 'Preferences',
            //step: "2 / 5",
            body: AppStrings.matchingFiltersTutorial,
            onSkip: () => controller.skip(),
            onNext: () => controller.next(),
          );
        },
      ),
    ],
  ),
];

final likesMatchTutorialTargets = [
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
            //  step: "3 / 5",
            body: AppStrings.heartTabTutorial,
            onSkip: () => controller.skip(),
            onNext: () => controller.next(),
          );
        },
      ),
    ],
  ),
];

final chatTutorialTargets = [
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
            // step: "4 / 5",
            body: AppStrings.chatTabTutorial,
            onSkip: () => controller.skip(),
            onNext: () => controller.next(),
          );
        },
      ),
    ],
  ),
];

final profileTutorialTargets = [
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
            //step: "5 / 5",
            body: AppStrings.userTabTutorial,
            onNext: () => controller.next(),
            next: 'Done',
          );
        },
      ),
    ],
  ),
];

void startGuidedTutorial(BuildContext context) {
  final tutorialNotifier = context.read<TourNotifier>();

  tutorialNotifier.setTab(0, context);

  // Mark tutorial as active
  tutorialNotifier.startTutorial();

  // Set function to start tutorials when tabs change
  tutorialNotifier.setTutorialStarter((context) {
    Future.delayed(const Duration(milliseconds: 300), () {
      showTutorialForTab(context, tutorialNotifier.currentIndex);
    });
  });

  // Start tutorial for the first tab
  showTutorialForTab(context, tutorialNotifier.currentIndex);
}

void showTutorialForTab(BuildContext context, int tabIndex) {
  final tutorialNotifier = context.read<TourNotifier>();

  List<TargetFocus> targets;

  // Load correct tutorial targets based on tab index
  switch (tabIndex) {
    case 0:
      targets = exploreTutorialTargets;
      break;
    case 1:
      targets = matchingTutorialTargets;
      break;
    case 2:
      targets = likesMatchTutorialTargets;
      break;
    case 3:
      targets = chatTutorialTargets;
      break;
    case 4:
      targets = profileTutorialTargets;
      break;
    default:
      return;
  }

  TutorialCoachMark(
    hideSkip: true,
    paddingFocus: 0,
    targets: targets,
    colorShadow: Colors.black.withOpacity(0.2),
    onSkip: () {
      tutorialNotifier.endTutorial();

      return true;
    },
    onFinish: () {
      int nextTab = tutorialNotifier.currentIndex + 1;

      if (nextTab < bottomNavItems.length) {
        tutorialNotifier.setTab(nextTab, context);
      } else {
        tutorialNotifier.endTutorial(); // Stop tutorial mode
      }
    },
  ).show(context: context);
}
