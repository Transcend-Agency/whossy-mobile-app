import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';
import 'package:whossy_mobile_app/feature/auth/sign_up/options_sheet.dart';
import 'package:whossy_mobile_app/view_model/auth_provider.dart';

import '../../../common/styles/text_style.dart';
import '../../../common/utils/index.dart';
import '../../../constants/index.dart';

@RoutePage()
class SignUpCreateScreen extends StatefulWidget {
  const SignUpCreateScreen({super.key});

  @override
  State<SignUpCreateScreen> createState() => _SignUpCreateScreenState();
}

class _SignUpCreateScreenState extends State<SignUpCreateScreen> {
  final myPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();

  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  late bool _passwordVisible;
  late bool _confirmPasswordVisible;

  bool _isPasswordEmpty = true;
  bool _isConfirmPasswordEmpty = true;

  Color passwordColor = AppColors.hintTextColor;
  Color confirmPasswordColor = AppColors.hintTextColor;

  void togglePasswordVisibility() {
    setState(() => _passwordVisible = !_passwordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
  }

  void _updatePasswordEmpty() {
    setState(() {
      _isPasswordEmpty = myPasswordController.text.isEmpty;
    });
  }

  void _updateConfirmPasswordEmpty() {
    setState(() {
      _isConfirmPasswordEmpty = confirmPasswordController.text.isEmpty;
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

  void _updateConfirmPasswordColor() {
    setState(() {
      confirmPasswordColor = confirmPasswordFocusNode.hasFocus
          ? AppColors.black
          : _isConfirmPasswordEmpty
              ? AppColors.hintTextColor
              : AppColors.black;
    });
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
    _confirmPasswordVisible = true;

    passwordFocusNode.addListener(_updatePasswordColor);
    myPasswordController.addListener(_updatePasswordEmpty);

    confirmPasswordFocusNode.addListener(_updateConfirmPasswordColor);
    confirmPasswordController.addListener(_updateConfirmPasswordEmpty);
  }

  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    formKey1.currentState?.dispose();

    myPasswordController.dispose();
    passwordFocusNode.dispose();
    formKey2.currentState?.dispose();

    confirmPasswordController.dispose();
    confirmPasswordFocusNode.dispose();
    formKey3.currentState?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: pagePadding,
      body: Consumer<AuthenticationProvider>(
        builder: (context, auth, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              addHeight(24),
              Text(
                "Create account",
                style: TextStyles.title.copyWith(fontSize: 24.sp),
              ),
              addHeight(4),
              Text(
                "Your perfect match is a swipe away :)",
                style: TextStyles.hintText.copyWith(
                  fontSize: AppUtils.scale(11.5.sp),
                ),
              ),
              addHeight(24),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  'Email',
                  style: TextStyles.fieldHeader,
                ),
              ),
              Form(
                key: formKey1,
                child: AppTextField(
                  focusNode: emailFocusNode,
                  textController: emailController,
                  hintText: AppStrings.emailHint,
                  validation: (email) => email?.trim().validateEmail(),
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
                child: AppTextField(
                  focusNode: passwordFocusNode,
                  textController: myPasswordController,
                  action: TextInputAction.done,
                  hintText: AppStrings.passwordHint,
                  obscureText: _passwordVisible,
                  validation: (value) => value.validatePassword(),
                  onFieldSubmitted: (password) => {},
                  suffixIcon: IconButton(
                    icon: visibilityIcon(_passwordVisible, passwordColor),
                    onPressed: togglePasswordVisibility,
                  ),
                ),
              ),
              Container(
                  padding: EdgeInsets.all(12.h),
                  margin: EdgeInsets.only(top: 14.h),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackGround.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(7, (index) {
                      if (index % 2 == 0) {
                        return passwordRequirementRow(
                            AppStrings.requirements[index ~/ 2]);
                      }
                      return addHeight(6);
                    }),
                  )),
              addHeight(24),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  'Confirm Password',
                  style: TextStyles.fieldHeader,
                ),
              ),
              Form(
                key: formKey3,
                child: AppTextField(
                  focusNode: confirmPasswordFocusNode,
                  textController: confirmPasswordController,
                  action: TextInputAction.done,
                  hintText: AppStrings.passwordHint,
                  obscureText: _confirmPasswordVisible,
                  validation: (value) => value.validatePassword(),
                  onFieldSubmitted: (password) => {},
                  suffixIcon: IconButton(
                    icon: visibilityIcon(
                        _confirmPasswordVisible, confirmPasswordColor),
                    onPressed: toggleConfirmPasswordVisibility,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: AppButton(
                  onPress: () => Nav.push(context, const SignUpNameRoute()),
                  text: 'Create Account',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 14.h),
                child: OutlinedAppButton(
                  onPress: () => showCustomModalBottomSheet(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'or sign up with',
                        style: TextStyles.buttonText.copyWith(
                          color: AppColors.hintTextColor,
                          fontSize: AppUtils.scale(17),
                        ),
                      ),
                      addWidth(5),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Icon(
                          IconlyLight.arrow_down_2,
                          size: 14.r,
                          color: AppColors.hintTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              PrivacyText(
                auth: auth,
                text: AppStrings.createAgreement,
              )
            ],
          );
        },
      ),
    );
  }
}

void showCustomModalBottomSheet(BuildContext context) {
  showModalBottomSheet<void>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => const SignupOptions(),
  );
}
