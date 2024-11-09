import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';
import 'package:whossy_app/feature/home/tabs/likes_and_match/data/state/likes_notifier.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class LikesGridView<T extends LikesAndMatch> extends StatelessWidget {
  const LikesGridView({
    super.key,
    required this.pageName,
  });

  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 14.h),
        child: Selector<T, Stream<List<UserProfile>>>(
          selector: (_, notifier) => notifier.profileStream,
          builder: (_, profileStream, __) {
            return StreamBuilder<List<UserProfile>>(
              stream: profileStream,
              builder: (context, snapshot) {
                return AppAnimatedSwitcher(
                  child: _buildContentBasedOnSnapshot(context, snapshot),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Function to handle the content building based on the snapshot state
  Widget _buildContentBasedOnSnapshot(
    BuildContext context,
    AsyncSnapshot<List<UserProfile>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return GridView.builder(
        key: const ValueKey('loading'),
        padding: EdgeInsets.zero,
        gridDelegate: _buildGridDelegate(context),
        itemCount: 14,
        itemBuilder: (context, index) {
          return ShimmerWidget.rectangular(
            border: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          );
        },
      );
    } else if (snapshot.hasError) {
      return Center(
        key: const ValueKey('error'),
        child: Text(
          'Error: ${snapshot.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else if (snapshot.hasData) {
      final tileData = snapshot.data!;

      return GridView.builder(
        key: const ValueKey('data'),
        padding: EdgeInsets.zero,
        gridDelegate: _buildGridDelegate(context),
        itemCount: tileData.length,
        itemBuilder: (ctx, item) => _buildGridItem(ctx, tileData[item]),
      );
    } else {
      return const Text('No data found');
    }
  }

  // Grid Delegate for both shimmer and data grids
  _buildGridDelegate(BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: (MediaQuery.sizeOf(context).width ~/ 160.r).toInt(),
      crossAxisSpacing: 6.w, // Spacing between columns
      mainAxisSpacing: 6.h, // Spacing between rows
      childAspectRatio: 1.15,
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
            showMessaging: true,
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
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBlurredViewButton(),
                _buildUserDetails(profile),
              ],
            ),
          ),
        ],
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${profile.user.firstName}, ',
            style: TextStyles.profileHead.copyWith(
              fontSize: AppUtils.scale(14.sp),
              color: Colors.white,
            ),
          ),
          Text(
            profile.preferences.dateOfBirth!.age.toString(),
            style: TextStyles.profileHead.copyWith(
              fontSize: AppUtils.scale(12.sp) ?? 16.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
          addWidth(6),
          if (profile.user.isVerified)
            SvgPicture.asset(AppAssets.tick, width: 18),
        ],
      ),
    );
  }
}
