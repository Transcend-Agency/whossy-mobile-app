import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
import 'package:whossy_mobile_app/constants/colors.dart';

import '../../../common/styles/text_style.dart';
import '../../../common/utils/index.dart';

@RoutePage()
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
          addHeight(24),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            visualDensity: VisualDensity.compact,
            leading: Text(' 🎉', style: TextStyle(fontSize: 20.sp)),
            subtitle: Text(
              "Please follow these community rules when looking for a match",
              style: TextStyles.hintText.copyWith(
                fontSize: AppUtils.scale(10.sp),
                color: AppColors.black,
              ),
            ),
            title: Text(
              'Be real',
              style: TextStyles.hintText.copyWith(
                fontSize: AppUtils.scale(12.sp),
                color: AppColors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
