import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../../../../provider/providers.dart';

@RoutePage()
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => context.read<SignUpNotifier>().reset(),
      child: AppScaffold(
        padding: pagePadding,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            addHeight(24),
            Row(
              children: [
                ShaderMask(
                  shaderCallback: (_) =>
                      AppColors.splashVariation.createShader(_),
                  blendMode: BlendMode.srcIn,
                  child: Text(
                    'Welcome to Whossy!',
                    style: TextStyles.welcome
                        .copyWith(fontSize: AppUtils.scale(24.sp)),
                  ),
                ),
                Text(
                  ' 🎉',
                  style: TextStyle(fontSize: 20.sp),
                ),
              ],
            ),
            addHeight(4),
            Text(
              "Please follow these community rules when looking for a match",
              style: TextStyles.hintText.copyWith(
                fontSize: AppUtils.scale(11.5.sp),
                color: AppColors.black,
              ),
            ),
            addHeight(20),
            ListView(
              shrinkWrap: true,
              children: List.generate(AppStrings.titles.length, (index) {
                return CustomTile(
                  leading: AppStrings.leadingEmojis[index],
                  title: AppStrings.titles[index],
                  subTitle: AppStrings.subtitles[index],
                  useSvg: (index == 1),
                  svgPath: (index == 1) ? AppAssets.exclamation : null,
                );
              }),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: AppButton(
                onPress: () => Nav.replace(context, const Wrapper()),
                text: 'I Agree',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
