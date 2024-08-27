import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/auth/login/data/state/login_notifier.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';

@RoutePage()
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late LoginNotifier _loginNotifier;
  final myEmailController = TextEditingController();

  final formKey1 = GlobalKey<FormState>();
  final shakeState1 = GlobalKey<ShakeState>();

  final emailFocusNode = FocusNode();

  void onContinuePressed() {
    if (formKey1.currentState!.validate()) {
      sendPasswordResetEmail();
    } else {
      shakeState1.currentState?.shake();
      return;
    }
  }

  Future<void> sendPasswordResetEmail() async {
    String email = myEmailController.text.trim();

    _loginNotifier.sendPasswordResetEmail(
      email: email,
      showSnackbar: showSnackbar,
      onAuthenticate: onAuthenticate,
    );
  }

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

  void onAuthenticate(String email) {
    Nav.push(context, ResetSuccessRoute(email: email));
  }

  @override
  void initState() {
    _loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    myEmailController.dispose();
    emailFocusNode.dispose();
    formKey1.currentState?.dispose();
    shakeState1.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      back: true,
      padding: pagePadding,
      body: Selector<LoginNotifier, bool>(
        selector: (_, auth) => auth.spinnerState,
        builder: (_, spinner, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SignupHeaderText(
                title: AppStrings.resetPasswordTitle,
                subtitle: AppStrings.resetPasswordSubtitle,
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
                    action: TextInputAction.done,
                    focusNode: emailFocusNode,
                    enabled: !spinner,
                    textController: myEmailController,
                    hintText: AppStrings.emailHint,
                    onFieldSubmitted: (email) => onContinuePressed(),
                    validation: (email) => email?.trim().validateEmail(),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 26.h),
                child: AppButton(
                  loading: spinner,
                  onPress: onContinuePressed,
                  text: AppStrings.sendLinkButton,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
