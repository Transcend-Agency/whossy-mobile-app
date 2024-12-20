import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/source/extensions.dart';

import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../common/utils/index.dart';

class MessageDetails extends StatelessWidget {
  const MessageDetails({
    super.key,
    required this.status,
    required this.time,
    required this.showStatus,
  });

  final MessageStatus? status;
  final Timestamp? time;
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            time.toTime(),
            style: TextStyles.chatText.copyWith(
              fontSize: AppUtils.scale(8.sp) ?? 10.5.sp,
            ),
          ),
          if (showStatus) ...[
            addWidth(6),
            messageStatus(status!, size: 16),
          ],
        ],
      ),
    );
  }
}
