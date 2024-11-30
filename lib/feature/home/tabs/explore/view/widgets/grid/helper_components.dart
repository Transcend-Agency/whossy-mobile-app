import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whossy_app/common/styles/text_style.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';

import '../../../../../../../common/components/index.dart';
import '../../../../../../../common/utils/index.dart';
import '../../../../../../../constants/index.dart';
import '../../../../matching/model/user_profile.dart';

Widget buildContentBasedOnSnapshot(
  BuildContext context,
  AsyncSnapshot<List<UserProfile>> snapshot,
) {
  if (snapshot.connectionState == ConnectionState.waiting) {
    return buildLoadingGrid(context);
  } else if (snapshot.hasError) {
    return buildErrorWidget(snapshot.error);
  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
    return buildEmptyData();
  } else if (snapshot.hasData) {
    return buildDataGrid(context, snapshot.data!);
  } else {
    return const Text('No data found');
  }
}

Widget buildEmptyData() {
  return const EmptyDataBox(
    key: ValueKey('empty'),
    imageSize: 100,
    image: AppAssets.noLikes,
    text: 'No search results',
  );
}

Widget buildLoadingGrid(BuildContext context) {
  int columns = (MediaQuery.sizeOf(context).width ~/ 160.r).toInt();

  final List<double> predefinedHeights = [180.h, 220.h, 240.h];

  return MasonryGridView.count(
    key: const ValueKey('loading'),
    crossAxisCount: columns,
    mainAxisSpacing: 6.h,
    crossAxisSpacing: 6.w,
    itemBuilder: (context, index) {
      final height = predefinedHeights[index % predefinedHeights.length];

      return ShimmerWidget.rectangular(
        height: height,
        border: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      );
    },
    itemCount: 12,
  );
}

Widget buildErrorWidget(Object? error) {
  return Center(
    key: const ValueKey('error'),
    child: Text(
      'Error: $error',
      style: const TextStyle(color: Colors.red),
    ),
  );
}

Widget buildDataGrid(BuildContext context, List<UserProfile> tileData) {
  const pageName = 'Explore';

  int columns = (MediaQuery.sizeOf(context).width ~/ 160.r).toInt();

  final List<double> predefinedHeights = [180.h, 220.h, 240.h];

  return MasonryGridView.count(
    key: const ValueKey('data'),
    crossAxisCount: columns,
    mainAxisSpacing: 6.h,
    crossAxisSpacing: 6.w,
    itemBuilder: (context, index) {
      if (index >= tileData.length) return const SizedBox();
      final item = tileData[index];

      final height = predefinedHeights[index % predefinedHeights.length];

      return Hero(
        tag: '${item.user.uid!}$pageName',
        child: GestureDetector(
          onTap: () => Nav.push(
            context,
            MatchingProfilePreview(
              index: 0,
              userProfile: item,
              showMessaging: true,
              pageName: pageName,
            ),
          ),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
            ),
            height: height,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: item.preferences.profilePics![0],
                  imageBuilder: (_, imageProvider) {
                    return Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  placeholder: (_, __) => const ShimmerWidget.rectangular(),
                  errorWidget: (context, url, error) {
                    log('Error loading image: ${error.toString()}');

                    return offline(size: 24);
                  },
                ),
                //Image.asset(item.imageUrl, fit: BoxFit.cover),
                ProfileShade(
                  heightFactor: 0.35,
                  gradient: AppColors.likesAndMatchShade,
                ),
                _buildUserTags(item),
                _buildUserDetails(item)
              ],
            ),
          ),
        ),
      );
    },
    itemCount: tileData.length,
  );
}

Widget _buildUserTags(UserProfile item) {
  return Align(
    alignment: Alignment.topLeft,
    child: Padding(
      padding: const EdgeInsets.only(left: 10, top: 8, right: 10),
      child: Wrap(
        runSpacing: 8,
        children: [
          if (item.newUser) ...[
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
          // Text(
          //   item.distance > 7
          //       ? item.country
          //       : "~ ${item.distance.ceil()} mi away",
          //   style: TextStyles.prefText.copyWith(
          //     color: Colors.white,
          //     fontSize: AppUtils.scale(9.5.sp),
          //   ),
          // ),
          if (item.isOnline) ...[
            // addWidth(8),
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

Widget _buildUserDetails(UserProfile item) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 6),
      child: Material(
        type: MaterialType.transparency,
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
              '${item.preferences.dateOfBirth?.age}',
              style: TextStyles.profileHead.copyWith(
                fontSize: AppUtils.scale(12.sp) ?? 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            addWidth(6),
            if (item.isUserVerified)
              SvgPicture.asset(AppAssets.tick, width: 18),
          ],
        ),
      ),
    ),
  );
}
