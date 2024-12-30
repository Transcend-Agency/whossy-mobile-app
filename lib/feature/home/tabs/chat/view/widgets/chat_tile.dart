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
    this.images,
    this.name,
    required this.isUserBlocked,
  });

  final bool isUserBlocked;
  final Chat data;
  final int oppIndex;
  final List<String>? images;
  final String? name;
  final VoidCallback? onTileTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      contentPadding: EdgeInsets.only(top: 6.h),
      leading: CircleAppAvatar(
        radius: 27,
        imageUrl: (images?.isNotEmpty ?? false) ? images![0] : null,
      ),
      horizontalTitleGap: 14,
      title: Text(
        name ?? 'Deleted Account',
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
            isUserBlocked ? 'User blocked' : data.lastMessage,
            style: TextStyles.hintThemeText.copyWith(
              fontSize: AppUtils.scale(10.sp) ?? 13.5.sp,
              fontStyle: isUserBlocked ? FontStyle.italic : null,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          addHeight(2),
        ],
      ),
      trailing: isUserBlocked
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                addHeight(4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6.r)),
                    color: AppColors.listTileColor,
                  ),
                  child: data.lastMessageTimestamp?.toTimestamp()?.toDate() !=
                          null
                      ? Text(
                          data.lastMessageTimestamp!.toTimestamp()!.toTime(),
                          style: TextStyles.hintThemeText.copyWith(
                            color: AppColors.black,
                            fontSize: AppUtils.scale(9.sp) ?? 12.5.sp,
                          ),
                        )
                      : const SizedBox.shrink(),
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
