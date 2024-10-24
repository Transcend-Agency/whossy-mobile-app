import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';
import 'package:whossy_app/feature/home/edit_profile/model/core_profile.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/router/router.gr.dart';
import '../../../../../provider/providers.dart';
import 'widgets/_.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: 375.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: pagePadding,
              child: Selector<EditProfileNotifier, CoreProfile?>(
                selector: (_, profile) => profile.staticProfile,
                builder: (_, data, __) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      HeaderBar(
                        icon: AppAssets.settings,
                        onIconTap: () => Nav.push(context, const Settings()),
                      ),
                      const Header(),
                      addHeight(8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${data?.firstName}, ',
                            style: TextStyles.profileHead.copyWith(
                              fontSize: AppUtils.scale(16.sp),
                            ),
                          ),
                          Text(
                            data?.dateOfBirth != null
                                ? data!.dateOfBirth!.age.toString()
                                : '',
                            style: TextStyles.profileHead.copyWith(
                              fontSize: AppUtils.scale(14.sp) ?? 16.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          addWidth(6),
                          SvgPicture.asset(
                            AppAssets.tick,
                            width: 18,
                          ),
                        ],
                      ),
                      addHeight(10),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            color: AppColors.black,
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 6.r, horizontal: 12.r),
                          child: Text(
                            '20% complete',
                            style: TextStyles.hintText.copyWith(
                              fontSize: AppUtils.scale(10.sp),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      addHeight(16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.optionsSheetDivider,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        padding: EdgeInsets.all(12.r),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              AppAssets.alert,
                              width: 24.r,
                            ),
                            addWidth(12),
                            SizedBox(
                              width: ScreenUtil().screenWidth * 0.75,
                              child: Text(
                                AppStrings.profileAddMore,
                                style: TextStyles.prefText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: const WhossySafetyGuide(),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CustomButton(
                            imagePath: AppAssets.boost,
                            title: 'Profile Boost',
                            subTitle: 'Get Now',
                            containerColor: AppColors.purpleContainer,
                            textColor: AppColors.purpleText,
                          ),
                          addWidth(10),
                          const CustomButton(
                            imagePath: AppAssets.credit,
                            title: '10 Credits',
                            subTitle: 'Get Now',
                            containerColor: AppColors.yellowContainer,
                            textColor: AppColors.yellowText,
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    addWidth(14),
                    PlanCard(
                      containerColor: AppColors.freeContainer,
                      containerShade: AppColors.freeContainerShade,
                      title: 'Whossy Free Plan',
                      amount: '0',
                      benefits: AppStrings.freePricing,
                      onSeeAllFeatures: () => Nav.push(
                        context,
                        SubscriptionPlans(initialPage: 0),
                      ),
                    ),
                    addWidth(12),
                    PlanCard(
                      containerColor: AppColors.premiumContainer,
                      containerShade: AppColors.premiumContainerShade,
                      title: 'Premium Plan',
                      amount: '12.99',
                      benefits: AppStrings.premiumPricing,
                      onSeeAllFeatures: () => Nav.push(
                        context,
                        SubscriptionPlans(initialPage: 1),
                      ),
                    ),
                    addWidth(12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
