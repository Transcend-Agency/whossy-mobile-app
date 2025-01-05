import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class LikesGridView extends StatelessWidget {
  const LikesGridView({
    super.key,
    required this.pageName,
    required this.data,
  });

  final String pageName;
  final List<UserProfile> data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 14.h),
        child: _buildGrid(context),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      gridDelegate: buildGridDelegate(context),
      itemCount: data.length,
      itemBuilder: (ctx, item) => _buildGridItem(ctx, data[item]),
    );
  }

  // Build individual grid item
  Widget _buildGridItem(BuildContext context, UserProfile profile) {
    return Hero(
      tag: '${profile.user.uid!}$pageName',
      child: GestureDetector(
        onTap: () => Nav.push(
          context,
          MatchingProfilePreview(
            index: 0,
            userProfile: profile,
            pageName: pageName,
          ),
        ),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: profile.preferences.profilePics![0],
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
              ProfileShade(
                heightFactor: 0.35,
                gradient: AppColors.likesAndMatchShade,
              ),
              _buildGridItemContent(profile),
            ],
          ),
        ),
      ),
    );
  }

  // Reusable content builder for each grid item
  Widget _buildGridItemContent(UserProfile profile) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10, bottom: 4, right: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBlurredViewButton(),
            _buildUserDetails(profile),
          ],
        ),
      ),
    );
  }

  // Blurred "View" button with reusable styling
  Widget _buildBlurredViewButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          color: Colors.white.withOpacity(0.2),
          child: Material(
            type: MaterialType.transparency,
            child: Text(
              'View',
              style: TextStyles.hintThemeText.copyWith(
                fontSize: AppUtils.scale(9.sp) ?? 13.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Build user details with name, age, and verified status
  Widget _buildUserDetails(UserProfile profile) {
    return Material(
        type: MaterialType.transparency,
        child: RichText(
          text: TextSpan(
            text: '${profile.user.firstName}, ',
            style: TextStyles.profileHead.copyWith(
              fontSize: AppUtils.scale(14.sp),
              color: Colors.white,
            ),
            children: [
              if (profile.preferences.dateOfBirth != null)
                TextSpan(
                  text: profile.preferences.dateOfBirth!.age.toString(),
                  style: TextStyles.profileHead.copyWith(
                    fontSize: AppUtils.scale(12.sp) ?? 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              if (profile.user.isApproved)
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: SvgPicture.asset(AppAssets.tick, width: 18),
                  ),
                ),
            ],
          ),
        ));
  }
}

// Grid Delegate for both shimmer and data grids
SliverGridDelegateWithFixedCrossAxisCount buildGridDelegate(
  BuildContext context,
) {
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: (MediaQuery.sizeOf(context).width ~/ 160.r).toInt(),
    crossAxisSpacing: 6.w, // Spacing between columns
    mainAxisSpacing: 6.h, // Spacing between rows
    childAspectRatio: 1.15,
  );
}
