import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../common/utils/router/router.gr.dart';
import '../../../../constants/index.dart';
import '../data/state/sign_up_notifier.dart';

class SignupOptions extends StatelessWidget {
  const SignupOptions({super.key});

  signUpWithGoogle(BuildContext context, SignUpNotifier data) async {
    showGoogleDialog(context);

    await data
        .signUpWithGoogle(
          showSnackbar: (message) =>
              showTopSnackBar(Overlay.of(context), AppSnackbar(text: message)),
          onAuthenticate: () {
            Nav.pushAndPopUntil(
                context, const SignUpNameRoute(), SignUpCreateRoute.name);
          },
        )
        .whenComplete(() => context.mounted ? Navigator.pop(context) : {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Consumer<SignUpNotifier>(
          builder: (_, data, __) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sign up options',
                        style: TextStyles.buttonText.copyWith(
                          fontSize: AppUtils.scale(17),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: SizedBox.square(
                          dimension: 30.r,
                          child: cancelIcon(),
                        ),
                      )
                    ],
                  ),
                ),
                const AppDivider(),
                addHeight(14),
                Padding(
                  padding: pagePadding,
                  child: OutlinedAppButton(
                    onPress: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        fbIcon(),
                        addWidth(6),
                        Text(
                          "Sign up with Facebook",
                          style: TextStyles.buttonText.copyWith(
                            color: AppColors.hintTextColor,
                            fontSize: AppUtils.scale(17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 12.r, horizontal: 14.w),
                  child: OutlinedAppButton(
                    onPress: () => signUpWithGoogle(context, data),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 0.9,
                          child: SvgPicture.asset(AppAssets.googleLogo),
                        ),
                        addWidth(8),
                        Text(
                          "Sign up with Google",
                          style: TextStyles.buttonText.copyWith(
                            color: AppColors.hintTextColor,
                            fontSize: AppUtils.scale(17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: pagePadding,
                  child: OutlinedAppButton(
                    onPress: () =>
                        Nav.push(context, PhoneNumberRoute(signIn: false)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        phone(),
                        addWidth(4),
                        Text(
                          "Sign up with Phone number",
                          style: TextStyles.buttonText.copyWith(
                            color: AppColors.hintTextColor,
                            fontSize: AppUtils.scale(17),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                addHeight(14),
              ],
            );
          },
        ),
      ),
    );
  }
}

void showSignUpOptionsSheet(BuildContext context) {
  showModalBottomSheet<void>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => const SignupOptions(),
  );
}
