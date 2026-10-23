import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/provider/provider.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/source/extensions.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/utils.dart';
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
    // Not a ListTile: its trailing slot is only as tall as the title and
    // subtitle, so the time badge overflowed once the text scaled up.
    return InkWell(
      splashColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTileTap,
      child: Padding(
        padding: EdgeInsets.only(top: 6.h),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.center,
                child: CircleAppAvatar(
                  radius: 27,
                  imageUrl: (images?.isNotEmpty ?? false) ? images![0] : null,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name ?? 'Deleted Account',
                      style: TextStyles.profileHead.copyWith(
                        fontSize: AppUtils.scale(12.sp) ?? 17,
                      ),
                    ),
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
              ),
              if (!isUserBlocked) ...[
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6.r)),
                        color: AppColors.listTileColor,
                      ),
                      child:
                          data.lastMessageTimestamp?.toTimestamp()?.toDate() !=
                                  null
                              ? Text(
                                  data.lastMessageTimestamp!
                                      .toTimestamp()!
                                      .toTime(),
                                  style: TextStyles.hintThemeText.copyWith(
                                    color: AppColors.black,
                                    fontSize: AppUtils.scale(9.sp) ?? 12.5.sp,
                                  ),
                                )
                              : const SizedBox.shrink(),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (data.lastSenderUserId ==
                            FirebaseAuth.instance.currentUser!.uid)
                          messageStatus(
                            context
                                .read<ChatsNotifier>()
                                .visibleStatus(data.lastMessageStatus!),
                          ),
                        addWidth(4),
                      ],
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
