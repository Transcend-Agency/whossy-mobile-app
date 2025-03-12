import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/provider.dart';
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
            ProfileView(
              size: Size(width.r, height.r),
              child: ProfileViewStack(
                imageUrl: profile.profilePics![0],
                likesCount: likesCount,
                labelText: 'Likes',
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
