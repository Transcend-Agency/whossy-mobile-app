import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/explore/data/source/matching_screen_mock_data.dart';
import 'package:whossy_app/feature/home/tabs/explore/model/explore_grid_item.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../data/source/explore_grid_mock_data.dart';

class ExploreGrid extends StatelessWidget {
  ExploreGrid({super.key});

  final random = Random();

  @override
  Widget build(BuildContext context) {
    // Calculate the number of columns based on screen width
    int columns = (MediaQuery.sizeOf(context).width ~/ 160.r).toInt();

    return Expanded(
      child: MasonryGridView.count(
        crossAxisCount: columns,
        mainAxisSpacing: 6.h,
        crossAxisSpacing: 6.w,
        itemBuilder: (context, index) {
          final item = exploreGridItems[index];

          final randomHeight = 150.h +
              random.nextInt(101).h; // Random height between 100 and 300

          return GestureDetector(
            onTap: () => Nav.push(
                context,
                MatchingRoute(
                    profile: dummyProfile, preferences: dummyPreferences)),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
              ),
              height: randomHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(item.imageUrl, fit: BoxFit.cover),
                  ProfileShade(
                    heightFactor: 0.35,
                    gradient: AppColors.likesAndMatchShade,
                  ),
                  _buildUserTags(item),
                  _buildUserDetails(item)
                ],
              ),
            ),
          );
        },
        itemCount: exploreGridItems.length,
      ),
    );
  }

  Widget _buildUserTags(ExploreGridItem item) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, top: 8, right: 10),
        child: Wrap(
          runSpacing: 8,
          children: [
            if (item.isNew) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6.r)),
                  color: AppColors.buttonColor,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      AppAssets.leaf,
                      width: 14,
                    ),
                    addWidth(4),
                    Text(
                      'New',
                      style: TextStyles.prefText.copyWith(
                        color: Colors.white,
                        fontSize: AppUtils.scale(9.5.sp) ?? 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              addWidth(8),
            ],
            Text(
              item.distance > 7
                  ? item.country
                  : "~ ${item.distance.ceil()} mi away",
              style: TextStyles.prefText.copyWith(
                color: Colors.white,
                fontSize: AppUtils.scale(9.5.sp),
              ),
            ),
            if (item.active) ...[
              addWidth(8),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF103B24),
                  border: Border.all(
                    color: const Color(0xFF09B45A),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 6.r, vertical: 1.r),
                child: Text(
                  'Active',
                  style: TextStyles.prefText.copyWith(
                    color: const Color(0xFF09B45A),
                    fontSize: AppUtils.scale(9.5.sp) ?? 11.sp,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // Build user details with name, age, and verified status
  Widget _buildUserDetails(ExploreGridItem item) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${item.name}, ',
              style: TextStyles.profileHead.copyWith(
                fontSize: AppUtils.scale(14.sp),
                color: Colors.white,
              ),
            ),
            Text(
              '${item.age}',
              style: TextStyles.profileHead.copyWith(
                fontSize: AppUtils.scale(12.sp) ?? 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            addWidth(6),
            if (item.isVerified) SvgPicture.asset(AppAssets.tick, width: 18),
          ],
        ),
      ),
    );
  }
}
