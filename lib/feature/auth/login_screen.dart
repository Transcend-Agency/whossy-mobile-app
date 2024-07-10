import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/extensions.dart';
import 'package:whossy_mobile_app/common/utils/widget_functions.dart';
import 'package:whossy_mobile_app/view_model/auth_provider.dart';

import '../../common/styles/text_style.dart';
import '../../constants/index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final myEmailController = TextEditingController();
  final myPasswordController = TextEditingController();

  final passwordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final shakeState1 = GlobalKey<ShakeState>();
  final shakeState2 = GlobalKey<ShakeState>();

  Color passwordColor = AppColors.hintTextColor;

  late bool _passwordVisible;
  bool _isPasswordEmpty = true;

  void toggleVisibility() {
    setState(() => _passwordVisible = !_passwordVisible);
  }

  void _updatePasswordEmpty() {
    setState(() {
      _isPasswordEmpty = myPasswordController.text.isEmpty;
    });
  }

  void _updatePasswordColor() {
    setState(() {
      passwordColor = passwordFocusNode.hasFocus
          ? AppColors.black
          : _isPasswordEmpty
              ? AppColors.hintTextColor
              : AppColors.black;
    });
  }

  void onLogin() {
    final email = formKey1.currentState?.validate();
    final password = formKey2.currentState?.validate();

    if (!email! && !password!) {
      shakeState1.currentState?.shake();
      shakeState2.currentState?.shake();
    } else if (!email) {
      shakeState1.currentState?.shake();
    } else if (!password!) {
      shakeState2.currentState?.shake();
    } else {
      return;
    }
    // Vibrate.feedback(FeedbackType.success);
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
    passwordFocusNode.addListener(_updatePasswordColor);
    myPasswordController.addListener(_updatePasswordEmpty);
  }

  @override
  void dispose() {
    myEmailController.dispose();
    myPasswordController.dispose();

    passwordFocusNode.dispose();
    emailFocusNode.dispose();

    formKey1.currentState?.dispose();
    formKey2.currentState?.dispose();

    shakeState1.currentState?.dispose();
    shakeState2.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: pagePadding,
      body: Consumer<AuthenticationProvider>(
        builder: (_, auth, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              addHeight(24),
              Text(
                AppStrings.welBack,
                style: TextStyles.title,
              ),
              Text(
                AppStrings.loginSub,
                style: TextStyles.hintText,
              ),
              addHeight(24),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  AppStrings.emailPhoneLabel,
                  style: TextStyles.fieldHeader,
                ),
              ),
              Form(
                key: formKey1,
                child: Shake(
                  key: shakeState1,
                  child: AppTextField(
                    focusNode: emailFocusNode,
                    textController: myEmailController,
                    hintText: AppStrings.emailHint,
                    validation: (email) => email?.trim().validateEmail(),
                  ),
                ),
              ),
              addHeight(12),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  AppStrings.passwordLabel,
                  style: TextStyles.fieldHeader,
                ),
              ),
              Form(
                key: formKey2,
                child: Shake(
                  key: shakeState2,
                  child: AppTextField(
                    focusNode: passwordFocusNode,
                    textController: myPasswordController,
                    action: TextInputAction.done,
                    hintText: AppStrings.passwordHint,
                    obscureText: _passwordVisible,
                    validation: (value) => value.validatePassword(),
                    onFieldSubmitted: (password) => onLogin(),
                    suffixIcon: IconButton(
                      icon: visibilityIcon(_passwordVisible, passwordColor),
                      onPressed: toggleVisibility,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => context.pushNamed('reset-1'),
                    child: Container(
                      margin: textTouchable,
                      child: Text(
                        AppStrings.forgotPassword,
                        style: TextStyles.fieldHeader.copyWith(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ), //
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20.h),
                child: AppButton(
                  onPress: onLogin,
                  text: AppStrings.loginButton,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Divider(
                    color: AppColors.black,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.white,
                    child: Text(
                      AppStrings.orDivider,
                      style: TextStyles.fieldHeader,
                    ),
                  ),
                ],
              ),
              addHeight(20),
              OutlinedAppButton(
                onPress: auth.signApple,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.apple_rounded,
                      color: Colors.black,
                      size: 32.r,
                    ),
                    addWidth(4),
                    Padding(
                      padding: EdgeInsets.only(top: 3.h),
                      child: Text(
                        AppStrings.signInApple,
                        style:
                            TextStyles.buttonText.copyWith(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              addHeight(12),
              OutlinedAppButton(
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
                      AppStrings.signInGoogle,
                      style:
                          TextStyles.buttonText.copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
              addHeight(12),
              OutlinedAppButton(
                onPress: auth.createNew,
                text: AppStrings.createAccountButton,
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 18.h, right: 8.w, left: 8.w),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColors.black,
                    ),
                    children: [
                      TextSpan(
                        text: AppStrings.loginAgreement,
                        style: TextStyles.fieldHeader,
                      ),
                      TextSpan(
                        text: AppStrings.termsAndConditions,
                        style: TextStyles.underlineText,
                        recognizer: TapGestureRecognizer()
                          ..onTap = auth.launchTC,
                      ),
                      TextSpan(
                        text: AppStrings.dataProcessingInfo,
                        style: TextStyles.fieldHeader,
                      ),
                      TextSpan(
                        text: AppStrings.privacyPolicy,
                        style: TextStyles.underlineText,
                        recognizer: TapGestureRecognizer()
                          ..onTap = auth.launchTC,
                      ),
                    ], //
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
