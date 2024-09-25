import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../model/chat.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({
    super.key,
    required this.tileData,
    required this.oppIndex,
    this.onTileTap,
  });

  final Chat tileData;
  final int oppIndex;
  final VoidCallback? onTileTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(top: 6.h),
      leading: CircleAvatar(
        backgroundColor: AppColors.listTileColor,
        radius: 30.r,
        child: _buildProfilePicture(),
      ),
      horizontalTitleGap: 14.r,
      title: Text(
        tileData.userNames[oppIndex],
        style: TextStyles.profileHead.copyWith(
          fontSize: AppUtils.scale(16.sp),
        ),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          addHeight(3),
          Text(
            tileData.lastMessage,
            style: TextStyles.prefText.copyWith(
              color: AppColors.hintTextColor,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          addHeight(2),
        ],
      ),
      trailing: Column(
        children: [
          addHeight(4),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6.r)),
              color: AppColors.listTileColor,
            ),
            child: Text(
              'Unread',
              style: TextStyles.prefText.copyWith(
                fontSize: AppUtils.scale(9.5.sp) ?? 11.sp,
              ),
            ),
          ),
        ],
      ),
      onTap: () => Nav.push(context, const ChatRoom()),
    );
  }

  Widget _buildProfilePicture() {
    final imageUrl = tileData.profilePicUrls[oppIndex];

    return imageUrl != null
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            imageBuilder: (_, imageProvider) {
              return Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
            placeholder: (_, __) => const ShimmerWidget.circular(),
            errorWidget: (_, __, ___) => offline(size: 28),
          )
        : user(size: 30.r);
  }
}
