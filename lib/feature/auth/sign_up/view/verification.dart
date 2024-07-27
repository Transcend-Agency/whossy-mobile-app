import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/feature/auth/sign_up/data/state/sign_up_notifier.dart';

import '../../../../common/styles/component_style.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../common/utils/router/router.gr.dart';
import '../../../../constants/index.dart';

@RoutePage()
class SignUpVerificationScreen extends StatefulWidget {
  const SignUpVerificationScreen({super.key, this.pop = false});

  // If pop is true I am coming from the login screen
  final bool pop;

  @override
  State<SignUpVerificationScreen> createState() =>
      _SignUpVerificationScreenState();
}

class _SignUpVerificationScreenState extends State<SignUpVerificationScreen> {
  final _countdownTimerKey = GlobalKey<CountdownTextState>();

  bool activateResend = false;
  int countDownDuration = 59;

  onFinished() {
    setState(() {
      activateResend = true;
    });
  }

  onPress() {
    if (widget.pop) {
      Navigator.pop(context);
    } else {
      Nav.replace(context, const WelcomeRoute());
    }
  }

  resendEmail(User? user) async {
    if (_countdownTimerKey.currentState != null) {
      _countdownTimerKey.currentState!.restartTimer();
    }

    setState(() {
      activateResend = false;
    });

    // Re-send email verification to new user
    await user!.sendEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: pagePadding,
      body: Selector<SignUpNotifier, User?>(
        selector: (_, auth) => auth.userCredential!.user,
        builder: (_, user, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SignupHeaderText(
                title: "Email verification",
                subtitle:
                    "A verification link has been sent to your email ${user!.email}."
                    " Kindly verify to complete account set up",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn’t receive any email?',
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
                          onTap: () => resendEmail(user),
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
                  onPress: onPress,
                  text: widget.pop ? 'Back to Login' : 'Continue',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
