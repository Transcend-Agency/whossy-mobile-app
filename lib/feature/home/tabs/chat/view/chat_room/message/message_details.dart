import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/source/extensions.dart';

import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../common/utils/index.dart';

class MessageDetails extends StatelessWidget {
  const MessageDetails({
    super.key,
    required this.status,
    required this.time,
  });

  final MessageStatus? status;
  final Timestamp? time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          messageStatus(status!),
          addWidth(4),
          Text(
            time.toTime(),
            style: TextStyles.chatText,
          ),
        ],
      ),
    );
  }
}
