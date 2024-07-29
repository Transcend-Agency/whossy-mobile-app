import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../data/state/sign_up_notifier.dart';

@RoutePage()
class SignUpNameScreen extends StatefulWidget {
  const SignUpNameScreen({super.key});

  @override
  State<SignUpNameScreen> createState() => _SignUpNameScreenState();
}

class _SignUpNameScreenState extends State<SignUpNameScreen> {
  late SignUpNotifier signUpProvider;

  final myFirstController = TextEditingController();
  final myLastController = TextEditingController();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final shakeState1 = GlobalKey<ShakeState>();
  final shakeState2 = GlobalKey<ShakeState>();

  final firstFocusNode = FocusNode();
  final lastFocusNode = FocusNode();

  void validate() {
    final isFirstValid = formKey1.currentState?.validate() ?? false;
    final isLastValid = formKey2.currentState?.validate() ?? false;

    if (isFirstValid && isLastValid) {
      setValue();
      return;
    }

    if (!isFirstValid) shakeState1.currentState?.shake();
    if (!isLastValid) shakeState2.currentState?.shake();
  }

  setValue() {
    final first = myFirstController.text.trim();
    final last = myLastController.text.trim();

    signUpProvider.updateAppUser(firstName: first, lastName: last);

    Nav.push(context, const SignUpPhoneRoute());
  }

  @override
  void initState() {
    super.initState();
    signUpProvider = Provider.of<SignUpNotifier>(context, listen: false);
  }

  @override
  void dispose() {
    formKey1.currentState?.dispose();
    formKey2.currentState?.dispose();

    firstFocusNode.dispose();
    lastFocusNode.dispose();

    myFirstController.dispose();
    myLastController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      back: true,
      padding: pagePadding,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SignupHeaderText(
                title: AppStrings.signUpTitle,
                subtitle: AppStrings.signUpSubtitle,
                mid: 8,
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  AppStrings.firstNameLabel,
                  style: TextStyles.fieldHeader,
                ),
              ),
              Form(
                key: formKey1,
                child: Shake(
                  key: shakeState1,
                  child: AppTextField(
                    focusNode: firstFocusNode,
                    textController: myFirstController,
                    hintText: AppStrings.firstNameHint,
                    validation: (name) => name?.trim().validateName(),
                  ),
                ),
              ),
              addHeight(12),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  AppStrings.lastNameLabel,
                  style: TextStyles.fieldHeader,
                ),
              ),
              Form(
                key: formKey2,
                child: Shake(
                  key: shakeState2,
                  child: AppTextField(
                    focusNode: lastFocusNode,
                    textController: myLastController,
                    action: TextInputAction.done,
                    hintText: AppStrings.lastNameHint,
                    onFieldSubmitted: (password) => validate(),
                    validation: (name) => name?.trim().validateName(),
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AppButton(
                  onPress: validate,
                  text: 'Continue',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
