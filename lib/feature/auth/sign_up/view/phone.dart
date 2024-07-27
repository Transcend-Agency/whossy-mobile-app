import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';
import 'package:whossy_mobile_app/feature/auth/sign_up/data/state/sign_up_notifier.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';

@RoutePage()
class SignUpPhoneScreen extends StatefulWidget {
  const SignUpPhoneScreen({super.key});

  @override
  State<SignUpPhoneScreen> createState() => _SignUpPhoneScreenState();
}

class _SignUpPhoneScreenState extends State<SignUpPhoneScreen> {
  late SignUpNotifier signUpProvider;

  Country? country;
  Country? origin;
  bool isLoading = false;

  String? existingPhoneNumber;
  Timer? _debounce;

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
    setState(() {
      country = c;

      if (existingPhoneNumber == 'Select a country code') {
        existingPhoneNumber = null;
      }
    });
  }

  void updateOrigin(Country c) {
    setState(() {
      origin = c;

      countryController.text = c.name;
    });
  }

  _onPhoneNumberChanged() async {
    String text = phoneController.text.trim();

    if (text.validatePhoneNumberInput()) {
      setState(() {
        isLoading = true;
        existingPhoneNumber = 'Checking ...';
      });

      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(
        const Duration(milliseconds: 1500),
        () async {
          final countryCode = '+${country?.phoneCode ?? ''}';
          // Perform the phone number availability check here
          final result = await signUpProvider
              .isPhoneUnique(text.formatNumber(countryCode));

          final unique = result['isEmpty'] ?? false;
          final message =
              result['message'] ?? 'Already registered with another account';

          if (mounted) {
            setState(() {
              existingPhoneNumber = unique ? null : message;

              if (existingPhoneNumber == null && country == null) {
                existingPhoneNumber = 'Select a country code';
              }

              isLoading = false;
            });
          }
        },
      );
    }
  }

  void validate() {
    final isPhoneValid = formKey2.currentState?.validate() ?? false;
    final isCountryValid = formKey3.currentState?.validate() ?? false;

    if (isPhoneValid && isCountryValid) {
      setValues();
      return;
    }

    if (!isPhoneValid) shakeState2.currentState?.shake();
    if (!isCountryValid) shakeState3.currentState?.shake();
  }

  // Save the values to the authentication provider and proceed
  void setValues() {
    final phone =
        phoneController.text.trim().formatNumber('+${this.country!.phoneCode}');
    final country = countryController.text.trim();

    signUpProvider.updateAppUser(phoneNumber: phone, countryOfOrigin: country);

    Nav.push(context, const SignUpGenderRoute());
  }

  @override
  void initState() {
    signUpProvider = Provider.of<SignUpNotifier>(context, listen: false);

    phoneController.addListener(_onPhoneNumberChanged);

    super.initState();
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

    _debounce?.cancel();

    super.dispose();
  }

  void showPicker({
    bool showCode = true,
    required void Function(Country) onSelect,
  }) {
    showCountryPicker(
      context: context,
      moveAlongWithKeyboard: true,
      showPhoneCode: showCode,
      countryListTheme: AppTheme().countryListTheme(),
      onSelect: onSelect,
    );
  }

  @override
  Widget build(BuildContext context) {
    double? padding = ScreenUtil().screenWidth > 500 ? 5 : 8;

    return AppScaffold(
      back: true,
      padding: pagePadding,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SignupHeaderText(
            title: "Just a few more steps to go!",
            subtitle:
                "Ensure you have access to the phone number entered in order to receive otp code.",
          ),
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
                validation: (_) =>
                    _?.trim().validatePhoneNumber(existingPhoneNumber),
                prefixIcon: GestureDetector(
                  onTap: () => showPicker(onSelect: updateCountry),
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
                              child: dropDownIcon(size: 14)),
                          const VerticalDivider(
                            indent: 12,
                            endIndent: 12,
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
              "Country of origin",
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
                suffixIcon: GestureDetector(
                  onTap: () =>
                      showPicker(showCode: false, onSelect: updateOrigin),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: dropDownIcon(),
                  ),
                ),
                onFieldSubmitted: (_) => validate(),
                validation: (_) => _?.trim().validateCountry(),
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
    );
  }
}
