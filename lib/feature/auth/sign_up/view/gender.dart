import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';
import 'package:whossy_mobile_app/feature/auth/sign_up/view_model/sign_up_provider.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/router/router.gr.dart';

@RoutePage()
class SignUpGenderScreen extends StatefulWidget {
  const SignUpGenderScreen({super.key});

  @override
  State<SignUpGenderScreen> createState() => _SignUpGenderScreenState();
}

class _SignUpGenderScreenState extends State<SignUpGenderScreen> {
  Gender? _gender;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      back: true,
      padding: pagePadding,
      body: Consumer<SignUpProvider>(
        builder: (_, auth, __) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              addHeight(24),
              Text(
                "Your account is almost ready",
                style: TextStyles.title.copyWith(fontSize: 24.sp),
              ),
              addHeight(4),
              Text(
                "Select your gender",
                style: TextStyles.hintText.copyWith(
                  fontSize: AppUtils.scale(11.5.sp),
                ),
              ),
              addHeight(24),
              Row(
                children: [
                  GenderButton(
                    label: 'Male',
                    value: Gender.male,
                    groupValue: _gender,
                    onChanged: (_) {
                      setState(() => _gender = _);
                    },
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
                  onPress: _gender != null
                      ? () {
                          auth.setGender(_gender!);

                          Nav.push(context, const WelcomeRoute());
                        }
                      : null,
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
