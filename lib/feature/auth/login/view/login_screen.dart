import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';
import 'package:whossy_mobile_app/feature/auth/login/data/state/login_notifier.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginNotifier loginNotifier;

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

  void validate() {
    final isEmailValid = formKey1.currentState?.validate() ?? false;
    final isPasswordValid = formKey2.currentState?.validate() ?? false;

    if (isEmailValid && isPasswordValid) {
      loginWithEmailAndPassword();
      return;
    }

    if (!isEmailValid) shakeState1.currentState?.shake();
    if (!isPasswordValid) shakeState2.currentState?.shake();
  }

  Future<void> loginWithEmailAndPassword() async {
    final email = myEmailController.text.trim();
    final password = myPasswordController.text;

    await loginNotifier.loginWithEmailAndPassword(
      email: email,
      password: password,
      showSnackbar: showSnackbar,
      onAuthenticate: onAuthenticate,
      showEmailSnackbar: showEmailSnackbar,
      toCreateAccount: toCreateAccount,
      toOnboarding: toOnboarding,
    );
  }

  Future<void> loginWithGoogle() async {
    await loginNotifier.loginWithGoogle(
      showSnackbar: showSnackbar,
      onAuthenticate: onAuthenticate,
      showEmailSnackbar: showEmailSnackbar,
      toCreateAccount: toCreateAccount,
      toOnboarding: toOnboarding,
    );
  }

  Future<void> loginWithFacebook() async {
    await loginNotifier.loginWithFacebook(
      showSnackbar: showSnackbar,
    );
  }

  // Function to show the "Email not verified" Snackbar
  void showEmailSnackbar(UserCredential credential) {
    if (mounted) {
      final user = credential.user!;

      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 5),
        AppSnackbar(
          text: 'Email not verified',
          label: 'Verify',
          onLabelTapped: () async {
            await user.sendEmailVerification();
            onVerifyTapped(credential);
          },
        ),
      );
    }
  }

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

  onAuthenticate() => Nav.replaceAll(context, [const HomeWrapper()]);

  toCreateAccount() => Nav.push(context, const SignUpNameRoute());

  toOnboarding() => Nav.push(context, const Wrapper());

  void onVerifyTapped(UserCredential credential) =>
      Nav.push(context, SignUpVerificationRoute(pop: true));

  @override
  void initState() {
    super.initState();
    _passwordVisible = true;
    passwordFocusNode.addListener(_updatePasswordColor);
    myPasswordController.addListener(_updatePasswordEmpty);

    loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
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
    bool useScroll = ScreenUtil().screenHeight < 756;
    return AppScaffold(
      useScrollView: useScroll,
      padding: pagePadding,
      body: Selector<LoginNotifier, bool>(
        selector: (_, auth) => auth.spinnerState,
        builder: (_, spinner, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SignupHeaderText(
                title: AppStrings.welBack,
                subtitle: AppStrings.loginSub,
              ),
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
                    enabled: !spinner,
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
                    enabled: !spinner,
                    focusNode: passwordFocusNode,
                    textController: myPasswordController,
                    action: TextInputAction.done,
                    hintText: AppStrings.passwordHint,
                    obscureText: _passwordVisible,
                    onFieldSubmitted: (password) => validate(),
                    validation: (pass) => pass?.checkLoginPassword(),
                    suffixIcon: IconButton(
                      icon: visibilityIcon(_passwordVisible, passwordColor),
                      onPressed: toggleVisibility,
                    ),
                  ),
                ),
              ), //
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () => Nav.push(context, const ResetPasswordRoute()),
                    child: Container(
                      margin: forgotTouchable,
                      child: Text(
                        AppStrings.forgotPassword,
                        style: TextStyles.fieldHeader.copyWith(
                          decoration: TextDecoration.underline,
                          fontSize: AppUtils.scale(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: AppButton(
                  onPress: validate,
                  text: AppStrings.loginButton,
                  loading: spinner,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: OutlinedAppButton(
                  onPress: () =>
                      Nav.replace(context, const SignUpCreateRoute()),
                  text: AppStrings.createAccountButton,
                ),
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  const Divider(
                    color: AppColors.outlinedColor,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.white,
                    child: Text(
                      AppStrings.orDivider,
                      style: TextStyles.fieldHeader
                          .copyWith(color: AppColors.hintTextColor),
                    ),
                  ),
                ],
              ),
              addHeight(16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedAppButton(
                    onPress: loginWithFacebook,
                    child: Center(
                      child: fbIcon(),
                    ),
                  ),
                  OutlinedAppButton(
                    onPress: loginWithGoogle,
                    child: Center(
                      child: Transform.scale(
                        scale: 0.9,
                        child: SvgPicture.asset(AppAssets.googleLogo),
                      ),
                    ),
                  ),
                  OutlinedAppButton(
                    onPress: () => Nav.push(context, PhoneNumberRoute()),
                    child: Center(
                      child: phone(),
                    ),
                  ),
                ],
              ),
              useScroll ? addHeight(60) : const Spacer(),
              PrivacyText(
                action: () {},
                text: AppStrings.loginAgreement,
              )
            ],
          );
        },
      ),
    );
  }
}
