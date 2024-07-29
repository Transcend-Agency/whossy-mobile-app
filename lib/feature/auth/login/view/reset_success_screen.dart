import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/component_style.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';

@RoutePage()
class ResetSuccessScreen extends StatefulWidget {
  const ResetSuccessScreen({super.key, required this.email});

  final String email;

  @override
  State<ResetSuccessScreen> createState() => _ResetSuccessScreenState();
}

class _ResetSuccessScreenState extends State<ResetSuccessScreen> {
  final _countdownTimerKey = GlobalKey<CountdownTextState>();

  bool activateResend = false;
  int countDownDuration = 59;

  onFinished() {
    setState(() {
      activateResend = true;
    });
  }

  resendEmail() async {
    if (_countdownTimerKey.currentState != null) {
      _countdownTimerKey.currentState!.restartTimer();
    }

    setState(() {
      activateResend = false;
    });

    // Re-send email verification to new user
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: widget.email)
        .then((_) => log('Sent verification email'));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      back: true,
      padding: pagePadding,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 6.w, top: 16.h),
                child: SizedBox.square(
                  dimension: 110.r,
                  child: Image.asset(AppAssets.success),
                ),
              ),
            ),
          ),
          const SignupHeaderText(
            top: 0,
            title: AppStrings.success,
            subtitle: AppStrings.reset,
          ),
          Row(
            children: [
              Text(
                'Didn’t receive any email? ',
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
                      onTap: () => resendEmail(),
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
        ],
      ),
    );
  }
}
