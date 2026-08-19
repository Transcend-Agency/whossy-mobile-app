import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/utils.dart';
import 'package:whossy_app/provider/provider.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../matching/model/user_profile.dart';

class OnlineStatus extends HookWidget {
  const OnlineStatus({super.key, required this.oppUserId});

  final String oppUserId;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    final chatsNotifier = context.read<ChatsNotifier>();

    final chatterStream = useMemoized(
      () => chatsNotifier.chatterDataStream(oppUserId),
      [oppUserId],
    );

    final snapshot = useStream(chatterStream);

    return AppAnimatedSwitcher(
      child: _buildStreamContent(snapshot, width),
    );
  }

  Widget _buildStreamContent(
    AsyncSnapshot<UserProfile?> snapshot,
    double width,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const SizedBox.square(dimension: 14);
    }

    if (snapshot.hasError) {
      log('An error occurred while streaming status: ${snapshot.error}');
      return const SizedBox.shrink();
    }

    final userProfile = snapshot.data;

    if (userProfile?.user.status?.lastSeen == null) {
      return const SizedBox.square(dimension: 14);
    }

    final status = userProfile!.user.status!;

    final otherUserBlockedIds = userProfile.user.blockedIds ?? [];
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    return Selector<EditProfileNotifier, List<String>>(
      selector: (_, edit) => edit.coreProfile?.blockedIds ?? [],
      builder: (_, blockedIds, __) {
        if (otherUserBlockedIds.contains(currentUserUid)) {
          return Text(
            'last seen a long time ago',
            style: TextStyles.hintThemeText.copyWith(
              fontSize: AppUtils.scale(10.5.sp) ?? 13.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        }

        return blockedIds.contains(oppUserId)
            ? Text(
                'last seen recently',
                style: TextStyles.hintThemeText.copyWith(
                  fontSize: AppUtils.scale(10.5.sp) ?? 13.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : status.isRecentlyOnline(Timestamp.now())
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Online',
                        style: TextStyles.hintThemeText,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      addWidth(4),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: greenDot(),
                      ),
                    ],
                  )
                : Text(
                    status.getLastSeen(Timestamp.now()),
                    style: TextStyles.hintThemeText.copyWith(
                      fontSize: AppUtils.scale(10.5.sp) ?? 13.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
      },
    );
  }
}
