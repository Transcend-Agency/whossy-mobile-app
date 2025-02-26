import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/providers.dart';
import '../../../../edit_profile/model/core_profile.dart';
import '../../../explore/model/liked_user_profile.dart';
import '../../model/likes_match_data.dart';
import 'grid_view.dart';
import 'loading_grid_view.dart';
import 'profile_view.dart';
import 'profile_view_stack.dart';

class Likes extends HookWidget {
  const Likes({super.key});

  final double height = 142;
  final double width = 135;

  static const name = 'likes';

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

    return Selector2<LikesNotifier, EditProfileNotifier, LikesMatchData>(
      selector: (_, likes, edit) => LikesMatchData(
        user: edit.coreProfile!,
        profileStream: likes.usersILikedStream(edit.coreProfile!.blockedIds),
      ),
      builder: (_, result, __) {
        return StreamBuilder<List<LikedUserProfile>>(
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
    AsyncSnapshot<List<LikedUserProfile>> snapshot,
    CoreProfile profile,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return LoadingGridView(
        key: const ValueKey('loading'),
        width: profile.premiumUser ? width.r : null,
        height: profile.premiumUser ? height.r : 150.h,
      );
    } else if (snapshot.hasError) {
      return const BadNetworkDialog(
        subtitle: AppStrings.deviceOffline,
      );
    } else if (snapshot.hasData) {
      final data = snapshot.data!;
      final likesCount = data.length;

      if (data.isEmpty) {
        return Column(
          key: const ValueKey('empty_data'),
          children: [
            addHeight(ScreenUtil().screenHeight * 0.3, isRsv: false),
            const EmptyDataBox(
              image: AppAssets.noLikes,
              text: 'You haven\'t liked anyone yet ',
            ),
          ],
        );
      } else {
        return Column(
          key: const ValueKey('data'),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            profile.premiumUser
                ? ProfileView(
                    size: Size(width.r, height.r),
                    child: ProfileViewStack(
                      imageUrl: profile.profilePics![0],
                      likesCount: likesCount,
                      labelText: 'Likes',
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
                          width: 136.r,
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
                            child: ProfileViewStack(
                              imageUrl: profile.profilePics![0],
                              likesCount: likesCount,
                              labelText: 'Likes',
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
                                "Upgrade to Premium and Chat with Likes.",
                                style: TextStyles.title.copyWith(
                                    fontSize: 20, color: Colors.white),
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
                                    gradient: AppColors.upgradeButtonGradient,
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
                      ],
                    ),
                  ),
            LikesGridView(pageName: Likes.name, data: data),
          ],
        );
      }
    } else {
      return const EmptyDataBox(
        image: AppAssets.noLikes,
        text: 'You haven\'t liked anyone yet ',
      );
    }
  }
}
