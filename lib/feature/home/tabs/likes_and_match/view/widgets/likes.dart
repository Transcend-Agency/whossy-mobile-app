import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/tabs/likes_and_match/view/widgets/profile_view.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../constants/index.dart';
import '../../../../edit_profile/model/core_profile.dart';
import 'likes_grid_view.dart';
import 'profile_view_stack.dart';

class Likes extends HookWidget {
  const Likes({super.key});

  final double height = 142;
  final double width = 135;

  @override
  Widget build(BuildContext context) {
    useAutomaticKeepAlive();

    final likesNotifier = useContext().read<LikesNotifier>();

    return StreamBuilder<int>(
      stream: likesNotifier.likesCount,
      builder: (context, snapshot) {
        return Selector<EditProfileNotifier, CoreProfile>(
          selector: (_, editProfile) => editProfile.coreProfile!,
          builder: (_, profile, __) {
            return AppAnimatedSwitcher(
              child: _buildContentBasedOnSnapshot(context, snapshot, profile),
            );
          },
        );
      },
    );
  }

  Widget _buildContentBasedOnSnapshot(
    BuildContext context,
    AsyncSnapshot<int> snapshot,
    CoreProfile profile,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Align(
        key: const ValueKey('loading'),
        alignment: Alignment.topLeft,
        child: ShimmerWidget.rectangular(
          height: profile.premiumUser ? height.r : 150.h,
          width: profile.premiumUser ? width.r : null,
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
                                'Subscribe to Premium to Chat Who Liked You',
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
            const LikesGridView<LikesNotifier>(pageName: 'likes'),
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
