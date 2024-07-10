import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/app_utils.dart';
import 'package:whossy_mobile_app/common/utils/extensions.dart';
import 'package:whossy_mobile_app/common/utils/theme/theme.dart';
import 'package:whossy_mobile_app/view_model/auth_provider.dart';

import '../../../common/styles/text_style.dart';
import '../../../common/utils/widget_functions.dart';
import '../../../constants/index.dart';

class SignUpDetailsScreen extends StatefulWidget {
  const SignUpDetailsScreen({super.key});

  @override
  State<SignUpDetailsScreen> createState() => _SignUpDetailsScreenState();
}

class _SignUpDetailsScreenState extends State<SignUpDetailsScreen> {
  Country? country;

  // Controllers
  final emailController = TextEditingController();
  final countryController = TextEditingController();
  final phoneController = TextEditingController();

  // Form keys
  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  // Shake state keys
  final shakeState1 = GlobalKey<ShakeState>();
  final shakeState2 = GlobalKey<ShakeState>();
  final shakeState3 = GlobalKey<ShakeState>();

  // Focus nodes
  final emailFocusNode = FocusNode();
  final countryFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  void updateCountry(Country c) {
    setState(() => country = c);
  }

  @override
  void dispose() {
    // Dispose controllers
    emailController.dispose();
    countryController.dispose();
    phoneController.dispose();

    // Dispose focus nodes
    emailFocusNode.dispose();
    countryFocusNode.dispose();
    phoneFocusNode.dispose();

    // Dispose form keys and shake states if necessary
    formKey1.currentState?.dispose();
    formKey2.currentState?.dispose();
    formKey3.currentState?.dispose();
    shakeState1.currentState?.dispose();
    shakeState2.currentState?.dispose();
    shakeState3.currentState?.dispose();

    super.dispose();
  }

  void showPicker() => showCountryPicker(
        context: context,
        moveAlongWithKeyboard: true,
        showPhoneCode: true,
        countryListTheme: AppTheme().cLThemeData(),
        onSelect: updateCountry,
      );

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
                "Just a few more steps to go!",
                style: TextStyles.title.copyWith(fontSize: 24.sp),
              ),
              Text(
                "Ensure you have access to the phone number entered in order to receive otp code.",
                style: TextStyles.hintText,
              ),
              addHeight(24),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  'Email',
                  style: TextStyles.fieldHeader,
                ),
              ),
              Form(
                key: formKey1,
                child: Shake(
                  key: shakeState1,
                  child: AppTextField(
                    focusNode: emailFocusNode,
                    textController: emailController,
                    hintText: AppStrings.emailHint,
                    validation: (email) => email?.trim().validateEmail(),
                  ),
                ),
              ),
              addHeight(12),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  "Phone number",
                  style: TextStyles.fieldHeader,
                ),
              ),
              Form(
                key: formKey2,
                child: Shake(
                  key: shakeState2,
                  child: AppTextField(
                    focusNode: phoneFocusNode,
                    textController: phoneController,
                    hintText: '(+1) 00 000 0000',
                    countryCode: country?.countryCode ?? '+1',
                    isPhone: true,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 3.w, right: 3.w),
                      child: GestureDetector(
                        onTap: showPicker,
                        child: SizedBox(
                          height: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                AppUtils.countryCodeToEmoji(
                                    country?.countryCode ?? 'US'),
                                style: const TextStyle(
                                  fontSize: 22,
                                ),
                              ),
                              addWidth(5),
                              Text(
                                country?.countryCode ?? 'US',
                                style: TextStyles.hintThemeText,
                              ),
                              addWidth(4),
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Icon(
                                  IconlyLight.arrow_down_2,
                                  size: 14.r,
                                  color: AppColors.hintTextColor,
                                ),
                              ),
                              const VerticalDivider(
                                indent: 10,
                                endIndent: 10,
                                color: AppColors.hintTextColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              addHeight(12),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  "Country",
                  style: TextStyles.fieldHeader,
                ),
              ),
              Form(
                key: formKey3,
                child: Shake(
                  key: shakeState3,
                  child: AppTextField(
                    focusNode: countryFocusNode,
                    textController: countryController,
                    hintText: "Select country",
                    validation: (email) => email?.trim().validateEmail(),
                  ),
                ),
              ),
              addHeight(12),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AppButton(
                  onPress: () {},
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
