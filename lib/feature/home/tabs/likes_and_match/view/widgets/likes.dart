import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import 'likes_grid_view.dart';

class Likes extends StatelessWidget {
  const Likes({super.key});

  final bool flag = true;
  final bool isPremium = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (flag)
          !isPremium
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: GradientOutlineBox(
                    child: Container(
                      height: 142.r,
                      width: 130.r,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(color: Colors.white, width: 3.r),
                      ),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              'assets/images/sp_1_1.png',
                              fit: BoxFit.cover,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18.r),
                                  gradient: AppColors.splashGradient,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.r,
                                  vertical: 2.r,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '24',
                                      style: TextStyles.hintThemeText.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    addWidth(4),
                                    SvgPicture.asset(
                                      AppAssets.love,
                                      width: 18,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 6.h),
                                child: const GradientChip(
                                  text: 'Likes',
                                  width: 54,
                                  height: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 150.h,
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    gradient: AppColors.splashGradient,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 110.w,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        padding: EdgeInsets.all(3.r),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                'assets/images/sp_1_1.png',
                                fit: BoxFit.cover,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.r),
                                    gradient: AppColors.splashGradient,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.r, vertical: 2.r),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '24',
                                        style:
                                            TextStyles.hintThemeText.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      addWidth(4),
                                      SvgPicture.asset(
                                        AppAssets.love,
                                        width: 18,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 6.h),
                                  child: const GradientChip(
                                    text: 'Likes',
                                    width: 54,
                                    height: 22,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      addWidth(10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Subscribe to Premium to Chat Who Liked You',
                              style: TextStyles.title
                                  .copyWith(fontSize: 20, color: Colors.white),
                              textAlign: TextAlign.left,
                            ),
                            addHeight(10),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.r, vertical: 6.r),
                              decoration: BoxDecoration(
                                gradient: AppColors.upgradeButtonGradient,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Text(
                                'UPGRADE',
                                style: TextStyles.pageHeader
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        flag
            ? const LikesGridView()
            : const EmptyDataBox(
                image: AppAssets.noLikes,
                text: 'No likes yet',
              ),
      ],
    );
  }
}
