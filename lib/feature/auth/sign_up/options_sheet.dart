import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/view_model/auth_provider.dart';

import '../../../common/components/index.dart';
import '../../../common/styles/text_style.dart';
import '../../../common/utils/index.dart';
import '../../../constants/index.dart';

class SignupOptions extends StatelessWidget {
  const SignupOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Consumer<AuthenticationProvider>(
        builder: (_, auth, __) {
          return Column(
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
                      style: TextStyles.fieldHeader.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.back(),
                      child:
                          SizedBox.square(dimension: 30.r, child: cancelIcon()),
                    )
                  ],
                ),
              ),
              const Divider(
                color: AppColors.hintTextColor,
                height: 0,
              ),
              addHeight(16),
              Padding(
                padding: pagePadding,
                child: OutlinedAppButton(
                  onPress: auth.signApple,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fbIcon(),
                      addWidth(6),
                      Padding(
                        padding: EdgeInsets.only(top: 3.h),
                        child: Text(
                          "Sign up with Facebook",
                          style: TextStyles.buttonText.copyWith(
                            color: AppColors.hintTextColor,
                            fontSize: AppUtils.scale(17),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 14.w),
                child: OutlinedAppButton(
                  onPress: auth.signGoogle,
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
                  onPress: auth.createNew,
                  text: AppStrings.createAccountButton,
                ),
              ),
              addHeight(18)
            ],
          );
        },
      ),
    );
  }
}
