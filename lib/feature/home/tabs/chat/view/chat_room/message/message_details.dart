import 'package:flutter/material.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/source/extensions.dart';

import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../common/utils/index.dart';
import '../../../model/message.dart';

class MessageDetails extends StatelessWidget {
  const MessageDetails({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          messageStatus(message.status!),
          addWidth(4),
          Text(
            message.timestamp.toTime(),
            style: TextStyles.chatText,
          ),
        ],
      ),
    );
  }
}
