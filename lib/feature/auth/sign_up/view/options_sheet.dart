import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';

class SignupOptions extends StatelessWidget {
  const SignupOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sign up options',
                  style: TextStyles.buttonText.copyWith(
                    fontSize: AppUtils.scale(17),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox.square(dimension: 30.r, child: cancelIcon()),
                )
              ],
            ),
          ),
          const Divider(
            color: AppColors.outlinedColor,
            height: 0,
          ),
          addHeight(16),
          Padding(
            padding: pagePadding,
            child: OutlinedAppButton(
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  fbIcon(),
                  addWidth(6),
                  Text(
                    "Sign up with Facebook",
                    style: TextStyles.buttonText.copyWith(
                      color: AppColors.hintTextColor,
                      fontSize: AppUtils.scale(17),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 14.w),
            child: OutlinedAppButton(
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: 0.9,
                    child: SvgPicture.asset(AppAssets.googleLogo),
                  ),
                  addWidth(8),
                  Text(
                    "Sign up with Google",
                    style: TextStyles.buttonText.copyWith(
                      color: AppColors.hintTextColor,
                      fontSize: AppUtils.scale(17),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: pagePadding,
            child: OutlinedAppButton(
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.phone,
                    color: AppColors.black,
                    size: 22.r,
                  ),
                  addWidth(4),
                  Text(
                    "Sign up with Phone number",
                    style: TextStyles.buttonText.copyWith(
                      color: AppColors.hintTextColor,
                      fontSize: AppUtils.scale(17),
                    ),
                  ),
                ],
              ),
            ),
          ),
          addHeight(18)
        ],
      ),
    );
  }
}
