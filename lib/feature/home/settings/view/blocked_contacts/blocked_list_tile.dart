import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/text_style.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/component_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';

class BlockedListTile extends StatelessWidget {
  const BlockedListTile({
    super.key,
    required this.profile,
    required this.handleUnblock,
  });

  final UserProfile profile;
  final VoidCallback handleUnblock;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      contentPadding: pagePadding.copyWith(top: 7.r, bottom: 4.r),
      leading: CircleAppAvatar(
        radius: 21,
        imageUrl: profile.preferences.profilePics?[0],
      ),
      horizontalTitleGap: 14,
      title: Text(
        profile.user.getName(),
        style: TextStyles.pageHeader.copyWith(
          fontSize: AppUtils.scale(17) ?? 15,
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6.r)),
          color: AppColors.primaryColor,
        ),
        child: Text(
          'Unblock',
          style: TextStyles.hintThemeText.copyWith(
            color: Colors.white,
            fontSize: AppUtils.scale(8.sp) ?? 11.5.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onTap: handleUnblock,
    );
  }
}
