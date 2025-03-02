import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../common/styles/component_style.dart';
import '../../constants/index.dart';
import 'settings/view/widgets/widgets.dart';

class GlobalKeys {
  // Global Key for the Like button
  static final GlobalKey likeButtonKey = GlobalKey();

  // Global Key for the Dislike button
  static final GlobalKey dislikeButtonKey = GlobalKey();

  // Global Key for the Undo button
  static final GlobalKey undoButtonKey = GlobalKey();

  // Global Keys for Bottom Navigation Items
  static final GlobalKey fireTabKey = GlobalKey();
  static final GlobalKey globalSearchTabKey = GlobalKey();
  static final GlobalKey heartTabKey = GlobalKey();
  static final GlobalKey chatTabKey = GlobalKey();
  static final GlobalKey userTabKey = GlobalKey();
}

final targets = [
  // // Tutorial for the 'Like' button
  // TargetFocus(
  //   paddingFocus: 4,
  //   identify: 'likeButton',
  //   keyTarget: GlobalKeys.likeButtonKey,
  //   contents: [
  //     TargetContent(
  //       align: ContentAlign.bottom,
  //       builder: (context, controller) => Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Like',
  //             style: TextStyles.boldPrefText.copyWith(
  //               fontWeight: FontWeight.w600,
  //               fontSize: AppUtils.scale(14.sp) ?? 15.5.sp,
  //               color: Colors.white,
  //             ),
  //           ),
  //           addHeight(10),
  //           Text(
  //             AppStrings.likeButtonTutorial,
  //             style: TextStyles.prefText.copyWith(
  //               fontWeight: FontWeight.w500,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ],
  // ),
  //
  // // Tutorial for the 'Dislike' button
  // TargetFocus(
  //   paddingFocus: 4,
  //   identify: 'dislikeButton',
  //   keyTarget: GlobalKeys.dislikeButtonKey,
  //   contents: [
  //     TargetContent(
  //       align: ContentAlign.bottom,
  //       builder: (context, controller) => Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Dislike',
  //             style: TextStyles.boldPrefText.copyWith(
  //               fontWeight: FontWeight.w600,
  //               fontSize: AppUtils.scale(14.sp) ?? 15.5.sp,
  //               color: Colors.white,
  //             ),
  //           ),
  //           addHeight(10),
  //           Text(
  //             AppStrings.dislikeButtonTutorial,
  //             style: TextStyles.prefText.copyWith(
  //               fontWeight: FontWeight.w500,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ],
  // ),
  //
  // // Tutorial for the 'Undo' button
  // TargetFocus(
  //   paddingFocus: 4,
  //   identify: 'undoButton',
  //   keyTarget: GlobalKeys.undoButtonKey,
  //   contents: [
  //     TargetContent(
  //       align: ContentAlign.bottom,
  //       builder: (context, controller) => Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text(
  //             'Undo',
  //             style: TextStyles.boldPrefText.copyWith(
  //               fontWeight: FontWeight.w600,
  //               fontSize: AppUtils.scale(14.sp) ?? 15.5.sp,
  //               color: Colors.white,
  //             ),
  //           ),
  //           addHeight(10),
  //           Text(
  //             AppStrings.undoButtonTutorial,
  //             style: TextStyles.prefText.copyWith(
  //               fontWeight: FontWeight.w500,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   ],
  // ),

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
