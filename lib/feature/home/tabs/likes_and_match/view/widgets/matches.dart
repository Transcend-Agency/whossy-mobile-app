import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import 'likes_grid_view.dart';

class Matches extends StatelessWidget {
  const Matches({super.key});

  final bool flag = true;
  final bool isPremium = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (flag)
          isPremium
              ? Align(
                  alignment: Alignment.centerLeft,
                  child: GradientOutlineBox(
                    gradient: AppColors.matchContainerGradient,
                    child: Container(
                      height: 144.r,
                      width: 132.r,
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
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 6.h),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(18.r),
                                    gradient: AppColors.matchContainerGradient,
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
                                        '2',
                                        style:
                                            TextStyles.hintThemeText.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      addWidth(4),
                                      SvgPicture.asset(
                                        AppAssets.fire,
                                        width: 16,
                                        colorFilter: const ColorFilter.mode(
                                          Colors.white,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                    ],
                                  ),
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
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    gradient: AppColors.matchContainerGradient,
                    borderRadius: BorderRadius.circular(18.r),
                  ),
                  child: Row(
                    children: [
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
                                gradient: AppColors.splashGradient,
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
                      // addWidth(2),
                      Image.asset(AppAssets.flame),
                    ],
                  ),
                ),
        flag
            ? const LikesGridView()
            : const EmptyDataBox(
                image: AppAssets.noMatches,
                text: 'No match yet ^_^',
              ),
      ],
    );
  }
}
