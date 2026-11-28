import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/source/extensions.dart';

import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../common/utils/utils.dart';
import '../../../model/delivery.dart';
import '../../widgets/tick_icon.dart';

class MessageDetails extends StatelessWidget {
  const MessageDetails({
    super.key,
    required this.time,
    this.tick,
  });

  final Timestamp? time;

  /// Ticks to show after the time; null for the other person's messages.
  final TickState? tick;

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
          if (tick != null) ...[
            addWidth(6),
            TickIcon(tick!),
          ],
        ],
      ),
    );
  }
}
