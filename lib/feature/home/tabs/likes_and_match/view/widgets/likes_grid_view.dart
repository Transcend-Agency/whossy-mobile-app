import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whossy_app/common/components/index.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../data/source/likes_mock_data.dart';
import '../../model/like_item.dart';

class LikesGridView extends StatelessWidget {
  const LikesGridView({super.key});

  // Simulate a Future with a delay of 3 seconds
  Future<String> _mockFuture() async {
    await Future.delayed(const Duration(seconds: 3));
    // throw Exception('An error occurred!'); // Uncomment to simulate error
    return "Data loaded successfully!";
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(top: 14.h),
        child: FutureBuilder<String>(
          future: _mockFuture(),
          builder: (context, snapshot) {
            return AppAnimatedSwitcher(
  
              child: _buildContentBasedOnSnapshot(context, snapshot),
            );
          },
        ),
      ),
    );
  }

  // Function to handle the content building based on the snapshot state
  Widget _buildContentBasedOnSnapshot(
      BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return GridView.builder(
        key: const ValueKey('loading'),
        padding: EdgeInsets.zero,
        gridDelegate: _buildGridDelegate(context),
        itemCount: 10,
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
      return GridView.builder(
        key: const ValueKey('data'),
        padding: EdgeInsets.zero,
        gridDelegate: _buildGridDelegate(context),
        itemCount: likeItems.length ~/ 4,
        itemBuilder: (_, __) => _buildGridItem(_, likeItems[__]),
      );
    } else {
      return const Text('No data found');
    }
  }

  // Grid Delegate for both shimmer and data grids
  _buildGridDelegate(BuildContext context) {
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: (MediaQuery.of(context).size.width ~/ 160.r).toInt(),
      crossAxisSpacing: 6.w, // Spacing between columns
      mainAxisSpacing: 6.h, // Spacing between rows
      childAspectRatio: 1.15,
    );
  }

  // Build individual grid item
  Widget _buildGridItem(BuildContext context, LikeItem item) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(item.imageUrl, fit: BoxFit.cover),
          ProfileShade(
            heightFactor: 0.35,
            gradient: AppColors.likesAndMatchShade,
          ),
          _buildGridItemContent(item),
        ],
      ),
    );
  }

  // Reusable content builder for each grid item
  Widget _buildGridItemContent(LikeItem item) {
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
                _buildUserDetails(item),
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
          child: Text(
            'View',
            style: TextStyles.hintThemeText.copyWith(
              fontSize: AppUtils.scale(9.sp) ?? 13.sp,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Build user details with name, age, and verified status
  Widget _buildUserDetails(LikeItem item) {
    return Row(
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
    );
  }
}
