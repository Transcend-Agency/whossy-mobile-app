import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';

import '../../../../../../../../common/styles/text_style.dart';
import '../../../../../../../../common/utils/index.dart';
import '../../../../../matching/model/user_profile.dart';

class UserDetails extends StatelessWidget {
  final UserProfile userProfile;
  final int columnCount;

  const UserDetails({
    super.key,
    required this.userProfile,
    required this.columnCount,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 6, right: 10),
        child: Material(
          type: MaterialType.transparency,
          child: RichText(
            text: TextSpan(
              text: '${userProfile.name}, ',
              style: TextStyles.profileHead.copyWith(
                fontSize: AppUtils.scale(14.sp),
                color: Colors.white,
              ),
              children: [
                if (userProfile.preferences.dateOfBirth != null)
                  TextSpan(
                    text: '${userProfile.preferences.dateOfBirth!.age}',
                    style: TextStyles.profileHead.copyWith(
                      fontSize: AppUtils.scale(12.sp) ?? 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                if (userProfile.isOnline)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: greenDot(),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
