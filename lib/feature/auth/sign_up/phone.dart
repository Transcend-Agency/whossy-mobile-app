import 'package:auto_route/auto_route.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';
import 'package:whossy_mobile_app/view_model/auth_provider.dart';

import '../../../common/styles/text_style.dart';
import '../../../common/utils/index.dart';
import '../../../constants/index.dart';

@RoutePage()
class SignUpPhoneScreen extends StatefulWidget {
  const SignUpPhoneScreen({super.key});

  @override
  State<SignUpPhoneScreen> createState() => _SignUpPhoneScreenState();
}

class _SignUpPhoneScreenState extends State<SignUpPhoneScreen> {
  Country? country;

  // Controllers
  final countryController = TextEditingController();
  final phoneController = TextEditingController();

  // Form keys
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();

  // Shake state keys
  final shakeState2 = GlobalKey<ShakeState>();
  final shakeState3 = GlobalKey<ShakeState>();

  // Focus nodes
  final countryFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();

  void updateCountry(Country c) {
    setState(() => country = c);
  }

  @override
  void dispose() {
    countryController.dispose();
    phoneController.dispose();

    // Dispose focus nodes
    countryFocusNode.dispose();
    phoneFocusNode.dispose();

    // Dispose form keys and shake states if necessary
    formKey2.currentState?.dispose();
    formKey3.currentState?.dispose();
    shakeState2.currentState?.dispose();
    shakeState3.currentState?.dispose();

    super.dispose();
  }

  void showPicker() => showCountryPicker(
        context: context,
        moveAlongWithKeyboard: true,
        showPhoneCode: true,
        countryListTheme: AppTheme().countryListTheme(),
        onSelect: updateCountry,
      );

  @override
  Widget build(BuildContext context) {
    double? padding = ScreenUtil().screenWidth > 500 ? 5 : 8;

    return AppScaffold(
      back: true,
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
              addHeight(4),
              Text(
                "Ensure you have access to the phone number entered in order to receive otp code.",
                style: TextStyles.hintText.copyWith(
                  fontSize: AppUtils.scale(11.5.sp),
                ),
              ),
              addHeight(24),
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
                    hintText:
                        '${country?.phoneCode != null ? '' : '(+1) '}00 000 0000',
                    isPhone: true,
                    prefixIcon: GestureDetector(
                      onTap: showPicker,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 3.w),
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
                                  fontSize: 23,
                                ),
                              ),
                              addWidth(padding),
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
                              country?.phoneCode != null
                                  ? Text('(+${country!.phoneCode})',
                                      style: TextStyles.fieldHeader)
                                  : const SizedBox.shrink(),
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
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: AppButton(
                  onPress: () => Nav.push(context, const SignUpGenderRoute()),
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
