import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/widget_functions.dart';
import 'package:whossy_app/feature/home/tabs/likes_and_match/data/state/likes_notifier.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import 'likes_grid_view.dart';

class Likes extends HookWidget {
  const Likes({super.key});

  final bool isPremium = true;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

    final likesNotifier = useContext().read<LikesNotifier>();

    return StreamBuilder<int>(
      stream: likesNotifier.likesCount,
      builder: (context, snapshot) {
        return AppAnimatedSwitcher(
          child: _buildContentBasedOnSnapshot(context, snapshot),
        );
      },
    );
  }

  Widget _buildContentBasedOnSnapshot(
    BuildContext context,
    AsyncSnapshot<int> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Align(
        key: const ValueKey('loading'),
        alignment: Alignment.topLeft,
        child: ShimmerWidget.rectangular(
          height: isPremium ? 142.r : 150.h,
          width: isPremium ? 130.r : null,
          border: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.r),
          ),
        ),
      );
    } else if (snapshot.hasError) {
      // Todo : Error handling
      return Center(
        key: const ValueKey('error'),
        child: Text(
          'Error: ${snapshot.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    } else if (snapshot.hasData) {
      final likesCount = snapshot.data!;

      if (likesCount == 0) {
        return Column(
          key: const ValueKey('empty_data'),
          children: [
            addHeight(ScreenUtil().screenHeight * 0.3, isRsv: false),
            const EmptyDataBox(
              image: AppAssets.noLikes,
              text: 'No likes yet',
            ),
          ], //
        );
      } else {
        return Column(
          key: const ValueKey('data'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Selector<EditProfileNotifier, String?>(
              selector: (_, editProfile) =>
                  editProfile.coreProfile?.profilePics?[0],
              builder: (_, picture, __) {
                return isPremium
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
                              border:
                                  Border.all(color: Colors.white, width: 3.r),
                            ),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: picture ?? '',
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
                                    placeholder: (_, __) =>
                                        const ShimmerWidget.rectangular(),
                                    errorWidget: (context, url, error) {
                                      log('Error loading image: ${error.toString()}');

                                      return offline(size: 24);
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(18.r),
                                        gradient: AppColors.splashGradient,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.r,
                                        vertical: 2.r,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            likesCount.toString(),
                                            style: TextStyles.hintThemeText
                                                .copyWith(
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
                                    CachedNetworkImage(
                                      imageUrl: picture ?? "",
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
                                      placeholder: (_, __) =>
                                          const ShimmerWidget.rectangular(),
                                      errorWidget: (context, url, error) {
                                        log('Error loading image: ${error.toString()}');

                                        return offline(size: 24);
                                      },
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18.r),
                                          gradient: AppColors.splashGradient,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.r, vertical: 2.r),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              likesCount.toString(),
                                              style: TextStyles.hintThemeText
                                                  .copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            addWidth(4),
                                            SvgPicture.asset(
                                              AppAssets.love,
                                              width: 18,
                                              colorFilter:
                                                  const ColorFilter.mode(
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
                                    style: TextStyles.title.copyWith(
                                        fontSize: 20, color: Colors.white),
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
                      );
              },
            ),
            const LikesGridView(pageName: 'likes'),
          ],
        );
      }
    } else {
      return const EmptyDataBox(
        image: AppAssets.noLikes,
        text: 'No likes yet',
      );
    }
  }
}
