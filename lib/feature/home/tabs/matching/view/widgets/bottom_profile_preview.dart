import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:readmore/readmore.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../constants/index.dart';
import '../../model/user_profile.dart';
import 'interests_widget.dart';

class BottomProfilePreview extends StatelessWidget {
  const BottomProfilePreview({
    super.key,
    this.showLess = false,
    required this.userProfile,
    this.activePage,
  });

  final bool showLess;
  final int? activePage;
  final UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Material(
          type: MaterialType.transparency,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  if (userProfile.user.status?.online == true)
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF103B24),
                        border: Border.all(
                          color: const Color(0xFF09B45A),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 2.h,
                        horizontal: 8.w,
                      ),
                      child: Text(
                        'Active',
                        style: TextStyles.prefText.copyWith(
                          color: const Color(0xFF09B45A),
                          fontSize: AppUtils.scale(9.5.sp) ?? 12.sp,
                        ),
                      ),
                    )
                  else if (userProfile.user.createdAt != null &&
                      DateTime.now()
                              .difference(userProfile.user.createdAt!.toDate())
                              .inDays <=
                          7)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 6.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6.r)),
                        color: AppColors.buttonColor,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            AppAssets.leaf,
                            width: 14,
                          ),
                          addWidth(4),
                          Text(
                            'New',
                            style: TextStyles.prefText.copyWith(
                              color: Colors.white,
                              fontSize: AppUtils.scale(9.5.sp) ?? 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  Text(
                    "  ~ 22 mi away",
                    style: TextStyles.prefText.copyWith(
                      color: Colors.white,
                      fontSize: AppUtils.scale(9.5.sp) ?? 12.sp,
                    ),
                  ),
                ],
              ),
              addHeight(2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${userProfile.user.firstName ?? " "}, ",
                        style: TextStyles.profileHead.copyWith(
                          fontSize: AppUtils.scale(23.sp) ?? 25.sp,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        userProfile.preferences.dateOfBirth!.age.toString(),
                        style: TextStyles.profileHead.copyWith(
                          fontSize: AppUtils.scale(19.sp) ?? 21.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                      addWidth(10),
                      SvgPicture.asset(
                        AppAssets.tick,
                        width: 24,
                      ),
                    ],
                  ),
                  if (showLess)
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Transform.rotate(
                          angle: math.pi,
                          child: SvgPicture.asset(
                            AppAssets.down,
                            width: 21,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (!showLess &&
                  userProfile.preferences.bio != null &&
                  userProfile.preferences.bio!.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 4.r),
                  child: ReadMoreText(
                    userProfile.preferences.bio!,
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    textAlign: TextAlign.left,
                    style: TextStyles.prefText.copyWith(
                      color: Colors.white,
                    ),
                    moreStyle: TextStyles.prefText.copyWith(
                      color: Colors.grey,
                    ),
                    lessStyle: TextStyles.prefText.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                ),
              if (!showLess)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 14, top: 8),
                      child: SvgPicture.asset(
                        AppAssets.interests,
                        width: 23,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
                    ),
                    Expanded(
                      child: InterestsWidget(userProfile: userProfile),
                    ),
                    addWidth(4),
                    GestureDetector(
                      onTap: () => Nav.push(
                        context,
                        UserProfilePreview(
                            index: activePage!, userProfile: userProfile),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Transform.rotate(
                          angle: 0,
                          child: SvgPicture.asset(
                            AppAssets.down,
                            width: 21,
                            colorFilter: const ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              if (!showLess)
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 20.h),
                  child: PageIndicator(
                    activePage: activePage!,
                    pageNo: userProfile.preferences.profilePics!.length,
                    height: 4,
                    activeColor: Colors.white,
                    inActiveColor: Colors.white.withOpacity(0.5),
                  ),
                )
              else
                addHeight(20)
            ],
          ),
        ),
      ),
    );
  }
}
