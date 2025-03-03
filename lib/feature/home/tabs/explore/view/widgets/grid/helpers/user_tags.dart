import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../../../common/styles/text_style.dart';
import '../../../../../../../../common/utils/utils.dart';
import '../../../../../../../../constants/index.dart';
import '../../../../../matching/model/user_profile.dart';

class UserTags extends StatelessWidget {
  final UserProfile userProfile;
  const UserTags({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 8, right: 10),
        child: Wrap(
          runSpacing: 8,
          children: [
            if (userProfile.newUser) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
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
                        fontSize: AppUtils.scale(9.5.sp) ?? 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              addWidth(8),
            ],
          ],
        ),
      ),
    );
  }
}
