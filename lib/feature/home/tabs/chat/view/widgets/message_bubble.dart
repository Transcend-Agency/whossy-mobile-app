import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/components/Avatar/app_avatar.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../model/message.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.data,
    required this.isSender,
    this.url,
  });

  final Message data;
  final bool isSender;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isSender) ...[
            addWidth(14),
            AppAvatar(imageUrl: url, radius: 17)
          ],
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
            margin: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
            decoration: bubbleDecoration(isSender),
            child: Text(
              data.message,
              style: TextStyles.prefText.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
