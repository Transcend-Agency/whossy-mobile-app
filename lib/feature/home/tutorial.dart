import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../common/styles/text_style.dart';
import '../../common/utils/index.dart';
import '../../constants/index.dart';

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

  // Tutorial for the 'Explore' tab (GlobalSearchTab)
  TargetFocus(
    identify: 'globalSearchTab',
    keyTarget: GlobalKeys.globalSearchTabKey,
    paddingFocus: 2,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Explore',
              style: TextStyles.boldPrefText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: AppUtils.scale(14.sp) ?? 15.5.sp,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                AppStrings.globalSearchTabTutorial,
                style: TextStyles.prefText.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            addHeight(25),
          ],
        ),
      ),
    ],
  ),

  // Tutorial for the 'Swipe and Match' tab (FireTab)
  TargetFocus(
    identify: 'fireTab',
    keyTarget: GlobalKeys.fireTabKey,
    paddingFocus: 2,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Swipe and Match',
              style: TextStyles.boldPrefText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: AppUtils.scale(14.sp) ?? 15.5.sp,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                AppStrings.fireTabTutorial,
                style: TextStyles.prefText.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            addHeight(25),
          ],
        ),
      ),
    ],
  ),

  // Tutorial for the 'Likes and Matches' tab (HeartTab)
  TargetFocus(
    identify: 'heartTab',
    keyTarget: GlobalKeys.heartTabKey,
    paddingFocus: 2,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Likes and Matches',
              style: TextStyles.boldPrefText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: AppUtils.scale(14.sp) ?? 15.5.sp,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                AppStrings.heartTabTutorial,
                style: TextStyles.prefText.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            addHeight(25),
          ],
        ),
      ),
    ],
  ),

  // Tutorial for the 'Chats' tab (ChatTab)
  TargetFocus(
    identify: 'chatTab',
    keyTarget: GlobalKeys.chatTabKey,
    paddingFocus: 2,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chats',
              style: TextStyles.boldPrefText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: AppUtils.scale(14.sp) ?? 15.5.sp,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                AppStrings.chatTabTutorial,
                style: TextStyles.prefText.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            addHeight(25),
          ],
        ),
      ),
    ],
  ),

  // Tutorial for the 'Profile' tab (UserTab)
  TargetFocus(
    identify: 'userTab',
    keyTarget: GlobalKeys.userTabKey,
    paddingFocus: 2,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        builder: (context, controller) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profile',
              style: TextStyles.boldPrefText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: AppUtils.scale(14.sp) ?? 15.5.sp,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Text(
                AppStrings.userTabTutorial,
                style: TextStyles.prefText.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
            addHeight(25),
          ],
        ),
      ),
    ],
  ),
];
