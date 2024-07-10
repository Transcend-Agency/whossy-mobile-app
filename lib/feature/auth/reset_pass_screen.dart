import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/extensions.dart';
import 'package:whossy_mobile_app/view_model/auth_provider.dart';

import '../../common/components/index.dart';
import '../../common/styles/text_style.dart';
import '../../common/utils/widget_functions.dart';
import '../../constants/index.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final myEmailController = TextEditingController();

  final formKey1 = GlobalKey<FormState>();
  final shakeState1 = GlobalKey<ShakeState>();

  final emailFocusNode = FocusNode();

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
      padding: pagePadding,
      body: Consumer<AuthenticationProvider>(
        builder: (_, auth, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              addHeight(24),
              Text(
                AppStrings.resetPasswordTitle,
                style: TextStyles.title,
              ),
              Text(
                AppStrings.resetPasswordSubtitle,
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 26.h),
                child: AppButton(
                  onPress: () {},
                  text: AppStrings.sendCodeButton,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
