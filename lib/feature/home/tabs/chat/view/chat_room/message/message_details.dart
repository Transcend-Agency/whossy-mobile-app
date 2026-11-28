import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/source/extensions.dart';

import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../common/utils/utils.dart';

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
            style: TextStyles.messageMeta,
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
