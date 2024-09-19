import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../common/utils/router/router.gr.dart';
import '../data/state/sign_up_notifier.dart';

@RoutePage()
class SignUpGenderScreen extends StatefulWidget {
  const SignUpGenderScreen({super.key});

  @override
  State<SignUpGenderScreen> createState() => _SignUpGenderScreenState();
}

class _SignUpGenderScreenState extends State<SignUpGenderScreen> {
  late SignUpNotifier signUpProvider;
  Gender? _gender;

  @override
  void initState() {
    signUpProvider = context.read<SignUpNotifier>();

    super.initState();
  }

  void onPress() {
    signUpProvider.completeCreation(
      gender: _gender!.name,
      showSnackbar: showSnackbar,
      onVerifyMail: onVerifyMail,
      toWelcome: toWelcome,
    );
  }

  onVerifyMail() =>
      Nav.pushAndPopUntil(context, SignUpVerificationRoute(), SplashRoute.name);

  toWelcome() =>
      Nav.pushAndPopUntil(context, const WelcomeRoute(), SplashRoute.name);

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
      body: Selector<SignUpNotifier, bool>(
        selector: (_, auth) => auth.spinnerState,
        builder: (_, spinner, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SignupHeaderText(
                title: "Your account is almost ready",
                subtitle: "Select your gender",
              ),
              Row(
                children: [
                  GenderButton(
                    label: 'Male',
                    value: Gender.male,
                    groupValue: _gender,
                    onChanged: (_) => setState(() => _gender = _),
                  ),
                  addWidth(6.w),
                  GenderButton(
                    label: 'Female',
                    value: Gender.female,
                    groupValue: _gender,
                    onChanged: (_) {
                      setState(() => _gender = _);
                    },
                  ),
                ],
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AppButton(
                  onPress: _gender != null ? onPress : null,
                  text: 'Continue',
                  loading: spinner,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
