import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/widget_functions.dart';
import 'package:whossy_mobile_app/constants/strings.dart';
import 'package:whossy_mobile_app/view_model/auth_provider.dart';

import '../../common/styles/text_style.dart';
import '../../common/utils/app_utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: pagePadding,
              child: Consumer<AuthenticationProvider>(
                builder: (_, auth, __) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      addHeight(16),
                      Text(
                        AppStrings.welBack,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 24.sp,
                          fontFamily: 'NeueMontreal',
                        ),
                      ),
                      Text(
                        "Login to see who you've matched with",
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontFamily: 'NeueMontreal',
                        ),
                      ),
                      addHeight(24),
                      Text(
                        "Email/Phone",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'NeueMontreal',
                        ),
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: 'NeueMontreal',
                        ),
                      ),
                      Text(
                        "Forgot Password",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NeueMontreal',
                          fontSize: 12.sp,
                        ),
                      ),
                      addHeight(20),
                      OutlinedAppButton(
                        onPress: auth.signApple,
                        text: 'Login',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign in with Apple',
                              style: TextStyles.buttonText
                                  .copyWith(color: Colors.black),
                              textScaler: AppUtils.scaleText(context),
                            ),
                          ],
                        ),
                      ),
                      addHeight(10),
                      OutlinedAppButton(
                        onPress: auth.signGoogle,
                        text: 'Login',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign in with Google',
                              style: TextStyles.buttonText
                                  .copyWith(color: Colors.black),
                              textScaler: AppUtils.scaleText(context),
                            ),
                          ],
                        ),
                      ),
                      addHeight(10),
                      OutlinedAppButton(
                        onPress: auth.createNew,
                        text: 'Create new account',
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    ); //
  }
}
