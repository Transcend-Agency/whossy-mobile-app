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
    required this.isPreviousSameSender,
    required this.isNextSameSender,
  });

  final Message data;
  final bool isSender;
  final String? url;
  final bool isPreviousSameSender;
  final bool isNextSameSender;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.topRight : Alignment.topLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!isSender && !isPreviousSameSender) ...[
            addWidth(10),
            AppAvatar(imageUrl: url, radius: 17)
          ] else if (!isSender) ...[
            addWidth(10),

            Visibility(
              visible: false, // Whether the avatar is visible or not
              maintainSize: true, // Maintains the widget's size
              maintainAnimation: true, // Keeps any animations active
              maintainState: true, // Keeps the state active
              maintainSemantics: true, // Maintains semantic information
              maintainInteractivity: false, // No need for interactivity
              child: AppAvatar(imageUrl: url, radius: 17),
            ),

            // addWidth(35)
          ],
          Container(
            padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
            margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10.w),
            decoration: bubbleDecoration(
              isSender,
              isPreviousSameSender,
              isNextSameSender,
            ),
            child: Text(
              data.message,
              style: TextStyles.chatText,
            ),
          ),
        ],
      ),
    );
  }
}
