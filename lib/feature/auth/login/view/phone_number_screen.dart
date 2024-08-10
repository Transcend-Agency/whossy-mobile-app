import 'package:auto_route/annotations.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';
import 'package:whossy_mobile_app/feature/auth/sign_up/data/repository/user_repository.dart';

import '../../../../common/styles/component_style.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../constants/index.dart';
import '../../../../provider/providers.dart';

@RoutePage()
class PhoneNumberScreen extends StatefulWidget {
  const PhoneNumberScreen({
    super.key,
    this.signIn = true,
  });

  final bool signIn;

  @override
  State<PhoneNumberScreen> createState() => _PhoneNumberScreenState();
}

class _PhoneNumberScreenState extends State<PhoneNumberScreen> {
  late LoginNotifier loginNotifier;
  final phoneController = TextEditingController();
  late UserRepository _userRepository;
  Country? country;
  bool isLoading = false;

  final formKey1 = GlobalKey<FormState>();
  final shakeState1 = GlobalKey<ShakeState>();

  final phoneFocusNode = FocusNode();

  String? existingPhoneNumber;
  final _debouncer = Debouncer(milliseconds: 1500);

  void updateCountry(Country c) {
    setState(() {
      country = c;

      if (existingPhoneNumber == 'Select a country code') {
        existingPhoneNumber = null;
      }
    });
  }

  void onContinuePressed() {
    if (formKey1.currentState!.validate()) {
      sendCode();
    } else {
      shakeState1.currentState?.shake();
      return;
    }
  }

  _onPhoneNumberChanged() async {
    String text = phoneController.text.trim();

    if (text.validatePhoneNumberInput()) {
      setState(() {
        isLoading = true;
        existingPhoneNumber = 'Checking ...';
      });

      _debouncer.run(() async {
        final countryCode = '+${country?.phoneCode ?? ''}';
        // Perform the phone number availability check here
        final result = await _userRepository.checkPhone(
          text.formatNumber(countryCode),
          exists: widget.signIn,
        );

        final unique = result['isEmpty'] ?? false;
        final message = result['message'] ?? widget.signIn
            ? 'Phone number not registered'
            : 'Already registered with another account';

        if (mounted) {
          setState(() {
            existingPhoneNumber = unique ? null : message;

            if (existingPhoneNumber == null && country == null) {
              existingPhoneNumber = 'Select a country code';
            }

            isLoading = false;
          });
        }
      });
    }
  }

  void sendCode() {
    final phone =
        phoneController.text.trim().formatNumber('+${country!.phoneCode}');

    loginNotifier.sendPhoneNumberCode(
      phone: phone,
      showSnackbar: showSnackbar,
      onSend: onSend,
    );
  }

  onSend(String phone, String id) {
    Nav.push(
      context,
      VerificationCodeRoute(phone: phone, verId: id, signIn: widget.signIn),
    );
  }

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
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
  void initState() {
    loginNotifier = Provider.of<LoginNotifier>(context, listen: false);

    _userRepository = UserRepository();

    phoneController.addListener(_onPhoneNumberChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double? padding = ScreenUtil().screenWidth > 500 ? 5 : 8;

    return AppScaffold(
      back: true,
      padding: pagePadding,
      body: Selector<LoginNotifier, bool>(
        selector: (_, auth) => auth.spinnerState,
        builder: (_, spinner, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SignupHeaderText(
                title: "Phone number Sign ${widget.signIn ? 'in' : 'up'}",
                subtitle: "Enter your phone number to receive an OTP code",
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 6.h),
                child: Text(
                  "Phone number",
                  style: TextStyles.fieldHeader,
                ),
              ),
              Form(
                key: formKey1,
                child: Shake(
                  key: shakeState1,
                  child: AppTextField(
                    enabled: !spinner,
                    focusNode: phoneFocusNode,
                    textController: phoneController,
                    hintText:
                        '${country?.phoneCode != null ? '' : '(+1) '}000 000 0000',
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 26.h),
                child: AppButton(
                  loading: spinner,
                  onPress: onContinuePressed,
                  text: 'Send code',
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
