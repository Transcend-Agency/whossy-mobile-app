import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';

import '../../../../common/styles/component_style.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../common/utils/router/router.gr.dart';
import '../../../../constants/index.dart';
import '../../../../provider/providers.dart';

@RoutePage()
class VerificationCodeScreen extends StatefulWidget {
  const VerificationCodeScreen({
    super.key,
    required this.phone,
    required this.verId,
    this.signIn = true,
    required this.resendToken,
  });

  final String phone;
  final String verId;
  final int? resendToken;
  final bool signIn;

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {
  final _countdownTimerKey = GlobalKey<CountdownTextState>();
  final otpController = TextEditingController();

  late LoginNotifier loginNotifier;
  late SignUpNotifier signUpNotifier;

  bool activateResend = false;
  int countDownDuration = 59;
  bool _isButtonEnabled = false;
  int? resendingToken;
  String? verId;

  @override
  void initState() {
    otpController.addListener(_handleOTPChange);

    loginNotifier = context.read<LoginNotifier>();
    signUpNotifier = context.read<SignUpNotifier>();

    resendingToken = widget.resendToken;
    verId = widget.verId;

    super.initState();
  }

  void _handleOTPChange() {
    setState(() => _isButtonEnabled = otpController.text.length == 6);
  }

  onFinished() {
    setState(() => activateResend = true);
  }

  @override
  void dispose() {
    otpController.removeListener(_handleOTPChange);
    super.dispose();
  }

  resendCode() async {
    if (_countdownTimerKey.currentState != null) {
      _countdownTimerKey.currentState!.restartTimer();
    }

    setState(() {
      activateResend = false;
    });

    // Re-send email verification to new user
    await resendVerification();
  }

  Future<void> resendVerification() async {
    await loginNotifier.sendPhoneNumberCode(
      phone: widget.phone,
      showSnackbar: showSnackbar,
      onSend: (_, id, token) {
        resendingToken = token;
        verId = id;
      },
      resendingToken: resendingToken,
      toCreateAccount: toCreateAccount,
      toOnboarding: toOnboarding,
      onAuthenticate: onLoginAuthenticate,
    );
  }

  Future<void> continueSignUp() async {
    await signUpNotifier.signUpWithPhone(
      id: verId!,
      phone: widget.phone,
      code: otpController.text,
      showSnackbar: showSnackbar,
      onAuthenticate: onSignUpAuthenticate,
    );
  }

  Future<void> continueLogin() async {
    await loginNotifier.loginWithPhoneNumber(
      id: verId!,
      code: otpController.text,
      showSnackbar: showSnackbar,
      toCreateAccount: toCreateAccount,
      toOnboarding: toOnboarding,
      onAuthenticate: onLoginAuthenticate,
    );
  }

  toOnboarding() =>
      Nav.pushAndPopUntil(context, const Wrapper(), LoginRoute.name);

  onLoginAuthenticate() => Nav.replaceAll(context, [const HomeWrapper()]);

  onSignUpAuthenticate() => Nav.pushAndPopUntil(
      context, const SignUpNameRoute(), SignUpCreateRoute.name);

  toCreateAccount() =>
      Nav.pushAndPopUntil(context, const SignUpNameRoute(), LoginRoute.name);

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      back: true,
      padding: pagePadding,
      body: Selector2<LoginNotifier, SignUpNotifier, bool>(
        selector: (_, login, signUp) {
          return widget.signIn ? login.spinnerState : signUp.spinnerState;
        },
        builder: (_, spinner, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SignupHeaderText(
                title: "Phone number Sign in",
                subtitle:
                    "A code has been sent to ${widget.phone}, enter to sign in",
              ),
              PinOTPField(controller: otpController),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn’t receive the code?',
                    style: TextStyles.bioText.copyWith(
                      fontSize: AppUtils.scale(11.5.sp),
                    ),
                  ),
                  addWidth(4),
                  !activateResend
                      ? Row(
                          children: [
                            Text(
                              'Resend in ',
                              style: TextStyles.bioText.copyWith(
                                fontSize: AppUtils.scale(11.5.sp),
                              ),
                            ),
                            CountdownText(
                              key: _countdownTimerKey,
                              textStyle: TextStyles.bioText.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                                fontSize: AppUtils.scale(11.5.sp),
                              ),
                              durationInSeconds: countDownDuration,
                              onTimerTick: (duration) => setState(() {}),
                              onFinished: onFinished,
                            ),
                            addWidth(3),
                            Text(
                              's',
                              style: TextStyles.bioText.copyWith(
                                fontSize: AppUtils.scale(11.5.sp),
                              ),
                            )
                          ],
                        )
                      : GestureDetector(
                          onTap: () => resendCode(),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            child: Text(
                              'Resend',
                              style: TextStyles.bioText.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.black,
                                fontSize: AppUtils.scale(11.5.sp),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AppButton(
                  loading: spinner,
                  onPress: _isButtonEnabled
                      ? widget.signIn
                          ? continueLogin
                          : continueSignUp
                      : null,
                  text: 'Continue',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
