import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/components/components.dart';
import '../../../../common/styles/component_style.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/utils.dart';
import '../../../../constants/index.dart';
import '../data/repository/authentication_repository.dart';

@RoutePage()
class ResetSuccessScreen extends StatefulWidget {
  const ResetSuccessScreen({super.key, required this.email});

  final String email;

  @override
  State<ResetSuccessScreen> createState() => _ResetSuccessScreenState();
}

class _ResetSuccessScreenState extends State<ResetSuccessScreen> {
  final _countdownTimerKey = GlobalKey<CountdownTextState>();

  final _authRepository = AuthenticationRepository();

  bool activateResend = false;
  bool resending = false;
  int countDownDuration = 59;

  onFinished() {
    setState(() {
      activateResend = true;
    });
  }

  void _showError(String message) => showSnackbar(message, context);

  /// Sends the link again and says whether it went. On success the countdown
  /// starts over; on failure Resend stays available so the user can try
  /// again once the problem (no connection, too many requests) clears.
  Future<void> resendEmail() async {
    if (resending) return;
    setState(() => resending = true);

    try {
      await _authRepository.resetPassword(widget.email);
      if (!mounted) return;
      showSnackbar(
        AppStrings.resetLinkResent,
        context,
        snackBarType: SnackbarType.success,
      );
      _countdownTimerKey.currentState?.restartTimer();
      setState(() => activateResend = false);
    } on FirebaseException catch (e) {
      handleFirebaseAuthError(e, _showError);
    } catch (e) {
      log(e.toString());
      _showError(AppStrings.errorUnknown);
    } finally {
      if (mounted) setState(() => resending = false);
    }
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
                      onTap: resending ? null : resendEmail,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        child: Text(
                          resending ? 'Sending…' : 'Resend',
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
