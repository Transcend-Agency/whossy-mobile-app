import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/edit_profile/model/core_profile.dart';
import 'package:whossy_app/feature/home/tabs/likes_and_match/model/likes_match_data.dart';
import 'package:whossy_app/feature/home/tabs/likes_and_match/view/widgets/profile_view.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../constants/index.dart';
import '../../../matching/model/user_profile.dart';
import 'grid_view.dart';
import 'loading_grid_view.dart';

class Matches extends HookWidget {
  const Matches({super.key});

  final double height = 144;
  final double width = 132;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

    return Selector2<MatchesNotifier, EditProfileNotifier, LikesMatchData>(
      selector: (_, match, edit) => LikesMatchData(
        user: edit.coreProfile!,
        profileStream: match.dataStream(edit.coreProfile!.blockedIds),
      ),
      builder: (_, result, __) {
        return StreamBuilder<List<UserProfile>>(
          stream: result.profileStream,
          builder: (context, snapshot) {
            return AppAnimatedSwitcher(
              child:
                  _buildContentBasedOnSnapshot(context, snapshot, result.user),
            );
          },
        );
      },
    );
  }

  Widget _buildContentBasedOnSnapshot(
    BuildContext context,
    AsyncSnapshot<List<UserProfile>> snapshot,
    CoreProfile profile,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return LoadingGridView(
        key: const ValueKey('loading'),
        width: profile.premiumUser ? width.r : null,
        height: profile.premiumUser ? height.r : 150.h,
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
      final data = snapshot.data!;
      final matchesCount = data.length;

      if (data.isEmpty) {
        return Column(
          key: const ValueKey('empty_data'),
          children: [
            addHeight(ScreenUtil().screenHeight * 0.3, isRsv: false),
            const EmptyDataBox(
              image: AppAssets.noMatches,
              imageSize: 100,
              text: 'No matches yet',
            ),
          ], //
        );
      } else {
        return Column(
          key: const ValueKey('data'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (profile.premiumUser)
              ProfileView(
                gradient: AppColors.matchContainerGradient,
                size: Size(width.r, height.r),
                child: profileViewStack(
                  matchesCount: matchesCount,
                  imageUrl: profile.profilePics![0],
                ),
              )
            else
              Container(
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
                            'Upgrade to Premium to Chat New Matches',
                            style: TextStyles.title
                                .copyWith(fontSize: 20, color: Colors.white),
                            textAlign: TextAlign.left,
                          ),
                          addHeight(10),
                          GestureDetector(
                            onTap: () => Nav.push(
                              context,
                              SubscriptionPlans(initialPage: 1),
                            ),
                            child: Container(
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
                          ),
                        ],
                      ),
                    ),
                    Image.asset(AppAssets.flame),
                  ],
                ),
              ),
            LikesGridView(pageName: 'matches', data: data),
          ],
        );
      }
    } else {
      return const EmptyDataBox(
        image: AppAssets.noMatches,
        imageSize: 100,
        text: 'No matches yet',
      );
    }
  }

  Widget profileViewStack({
    required int matchesCount,
    required String imageUrl,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
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
                    matchesCount.toString(),
                    style: TextStyles.hintThemeText.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: AppUtils.scale(10.sp) ?? 13.5.sp,
                    ),
                  ),
                  addWidth(5),
                  SvgPicture.asset(
                    AppAssets.fire,
                    width: 14,
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
    );
  }
}
