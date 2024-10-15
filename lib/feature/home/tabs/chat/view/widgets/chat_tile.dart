import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/source/extensions.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../model/chat.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.data,
    required this.oppIndex,
    this.onTileTap,
  });

  final Chat data;
  final int oppIndex;
  final VoidCallback? onTileTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      contentPadding: EdgeInsets.only(top: 6.h),
      leading: AppAvatar(
        radius: 27,
        imageUrl: data.profilePicUrls[oppIndex],
      ),
      horizontalTitleGap: 14,
      title: Text(
        data.userNames[oppIndex],
        style: TextStyles.profileHead.copyWith(
          fontSize: AppUtils.scale(12.sp) ?? 17,
        ),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addHeight(3),
          Text(
            data.lastMessage,
            style: TextStyles.hintThemeText.copyWith(
              fontSize: AppUtils.scale(10.sp) ?? 13.5.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          addHeight(2),
        ],
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          addHeight(4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.r)),
              color: AppColors.listTileColor,
            ),
            child: Text(
              data.lastMessageTimestamp!.toTime(),
              style: TextStyles.hintThemeText.copyWith(
                color: AppColors.black,
                fontSize: AppUtils.scale(9.sp) ?? 12.5.sp,
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (data.lastSenderUserId ==
                  FirebaseAuth.instance.currentUser!.uid)
                messageStatus(data.lastMessageStatus!),
              addWidth(4),
            ],
          ),
        ],
      ),
      onTap: onTileTap,
    );
  }
}
