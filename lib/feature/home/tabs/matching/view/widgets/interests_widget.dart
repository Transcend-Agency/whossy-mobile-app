import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/styles/text_style.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/providers.dart';

class InterestsWidget extends StatelessWidget {
  final UserProfile userProfile;

  const InterestsWidget({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: userProfile.preferences.ticks != null
          ? Selector<EditProfileNotifier, List<String>?>(
              selector: (_, editProfile) => editProfile.coreProfile?.interests,
              builder: (_, interests, __) {
                return Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: userProfile.preferences.ticks!.take(6).map((item) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: const Color(0xFF101010),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 6.r,
                            horizontal: 8.r,
                          ),
                          child: Text(
                            item,
                            style: TextStyles.hintText.copyWith(
                              fontSize: AppUtils.scale(10.sp),
                              color: AppColors.hintTextColor,
                            ),
                          ),
                        ),
                        // Show star if item exists in interests
                        if (interests != null && interests.contains(item))
                          Positioned(
                            top: -2,
                            right: -6,
                            child: SvgPicture.asset(
                              AppAssets.star,
                              width: 14,
                            ),
                          ),
                      ],
                    );
                  }).toList(),
                );
              },
            )
          : null,
    );
  }
}
