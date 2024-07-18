import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';
import 'package:whossy_mobile_app/view_model/auth_provider.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';

@RoutePage()
class SignUpNameScreen extends StatefulWidget {
  const SignUpNameScreen({super.key});

  @override
  State<SignUpNameScreen> createState() => _SignUpNameScreenState();
}

class _SignUpNameScreenState extends State<SignUpNameScreen> {
  final myFirstController = TextEditingController();
  final myLastController = TextEditingController();

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final shakeState1 = GlobalKey<ShakeState>();
  final shakeState2 = GlobalKey<ShakeState>();

  final firstFocusNode = FocusNode();
  final lastFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      back: true,
      resizeToAvoidBottomInset: true,
      padding: pagePadding,
      body: Consumer<AuthenticationProvider>(
        builder: (_, auth, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              addHeight(24),
              Text(
                AppStrings.signUpTitle,
                style: TextStyles.title.copyWith(fontSize: 24.sp),
              ),
              addHeight(8),
              Text(
                AppStrings.signUpSubtitle,
                style: TextStyles.hintText
                    .copyWith(fontSize: AppUtils.scale(11.5.sp)),
              ),
              addHeight(24),
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
                    onFieldSubmitted: (password) => {},
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AppButton(
                  onPress: () => Nav.push(context, const SignUpPhoneRoute()),
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
