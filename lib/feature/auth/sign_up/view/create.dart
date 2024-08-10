import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';
import 'package:whossy_mobile_app/feature/auth/sign_up/view/options_sheet.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../data/state/sign_up_notifier.dart';

@RoutePage()
class SignUpCreateScreen extends StatefulWidget {
  const SignUpCreateScreen({super.key});

  @override
  State<SignUpCreateScreen> createState() => _SignUpCreateScreenState();
}

class _SignUpCreateScreenState extends State<SignUpCreateScreen> {
  final List<bool> _validationStates = List.filled(4, false);
  late SignUpNotifier signUpProvider;

  final myPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final emailController = TextEditingController();
  final requirements = AppStrings.requirements;

  final passwordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();
  final emailFocusNode = FocusNode();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  final shakeState1 = GlobalKey<ShakeState>();
  final shakeState3 = GlobalKey<ShakeState>();

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

  void _validatePassword() {
    final password = myPasswordController.text;

    setState(() {
      _validationStates[0] = password.length >= 8;
      _validationStates[1] = RegExp(r'[a-z]').hasMatch(password) &&
          RegExp(r'[A-Z]').hasMatch(password);
      _validationStates[2] = RegExp(r'\d').hasMatch(password);
      _validationStates[3] =
          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);
    });
  }

  void validate() {
    final isEmailValid = formKey1.currentState?.validate() ?? false;
    final isPasswordValid = myPasswordController.text.validatePassword();
    final isConPasswordValid = formKey3.currentState?.validate() ?? false;

    if (isEmailValid && isPasswordValid && isConPasswordValid) {
      checkEmailAndPassword();
      return;
    }

    if (!isEmailValid) shakeState1.currentState?.shake();
    if (!isConPasswordValid) shakeState3.currentState?.shake();
  }

  Future<void> checkEmailAndPassword() async {
    final email = emailController.text.trim();
    final password = myPasswordController.text;

    await signUpProvider.signUpWithEmail(
      email: email,
      password: password,
      showSnackbar: showSnackbar,
      onAuthenticate: goToNext,
    );
  }

  goToNext() => Nav.replace(context, const SignUpNameRoute());

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
    _confirmPasswordVisible = true;

    passwordFocusNode.addListener(_updatePasswordColor);
    myPasswordController.addListener(_updatePasswordEmpty);
    myPasswordController.addListener(_validatePassword);

    confirmPasswordFocusNode.addListener(_updateConfirmPasswordColor);
    confirmPasswordController.addListener(_updateConfirmPasswordEmpty);

    signUpProvider = Provider.of<SignUpNotifier>(context, listen: false);
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
    bool useScroll = ScreenUtil().screenHeight < 850;
    return AppScaffold(
      back: true,
      padding: pagePadding,
      useScrollView: useScroll,
      resizeToAvoidBottomInset: true,
      body: Selector<SignUpNotifier, bool>(
        selector: (_, auth) => auth.spinnerState,
        builder: (_, spinner, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SignupHeaderText(
                title: "Create account",
                subtitle: "Your perfect match is a swipe away :)",
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  'Email',
                  style: TextStyles.fieldHeader,
                ),
              ),
              Form(
                key: formKey1,
                child: Shake(
                  key: shakeState1,
                  child: AppTextField(
                    focusNode: emailFocusNode,
                    textController: emailController,
                    hintText: AppStrings.emailHint,
                    enabled: !spinner,
                    keyboardType: TextInputType.emailAddress,
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
                child: AppTextField(
                  focusNode: passwordFocusNode,
                  textController: myPasswordController,
                  hintText: AppStrings.passwordHint,
                  enabled: !spinner,
                  obscureText: _passwordVisible,
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
                    children:
                        List.generate(requirements.length * 2 - 1, (index) {
                      if (index.isEven) {
                        int requirementIndex = index ~/ 2;
                        return passwordRequirementRow(
                          requirements[requirementIndex],
                          checked: _validationStates[requirementIndex],
                        );
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
                child: Shake(
                  key: shakeState3,
                  child: AppTextField(
                    enabled: !spinner,
                    focusNode: confirmPasswordFocusNode,
                    textController: confirmPasswordController,
                    action: TextInputAction.done,
                    hintText: AppStrings.passwordHint,
                    obscureText: _confirmPasswordVisible,
                    validation: (value) =>
                        value.validateConfirmPassword(myPasswordController),
                    onFieldSubmitted: (password) => validate(),
                    suffixIcon: IconButton(
                      icon: visibilityIcon(
                          _confirmPasswordVisible, confirmPasswordColor),
                      onPressed: toggleConfirmPasswordVisibility,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: AppButton(
                  onPress: validate,
                  text: 'Create Account',
                  loading: spinner,
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
              useScroll ? addHeight(60) : const Spacer(),
              PrivacyText(
                action: () {},
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
