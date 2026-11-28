import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../constants/colors.dart';
import '../../../../../../provider/provider.dart';
import '../../model/message.dart';
import '../../model/reply_to.dart';
import 'message/reply_quote.dart';

/// "Replying to" bar shown above the message input while a reply is being
/// written. The cross cancels the reply.
class ReplyBar extends StatelessWidget {
  const ReplyBar({super.key});

  @override
  Widget build(BuildContext context) {
    final replyingTo = context.select<ChatsNotifier, Message?>(
      (n) => n.replyingTo,
    );
    final fontSize = context.select<ChatTextSizeNotifier, double>(
      (n) => n.fontSize,
    );

    return AnimatedSize(
      duration: const Duration(milliseconds: 150),
      alignment: Alignment.bottomCenter,
      child: replyingTo == null
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: ReplyQuote(
                key: const ValueKey('reply_bar'),
                name: _name(context, replyingTo),
                preview: ReplyTo.quoting(
                  id: replyingTo.id,
                  senderId: replyingTo.senderId,
                  message: replyingTo.message,
                  photo: replyingTo.photo,
                  localPhoto: replyingTo.localPhoto,
                ).preview,
                isOwn: _isOwn(replyingTo),
                fontSize: fontSize,
                background: AppColors.listTileColor,
                expand: true,
                trailing: IconButton(
                  key: const ValueKey('cancel_reply'),
                  tooltip: 'Cancel reply',
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: AppColors.messageMetaColor,
                  ),
                  onPressed: () => context.read<ChatsNotifier>().cancelReply(),
                ),
              ),
            ),
    );
  }

  bool _isOwn(Message message) =>
      message.senderId == FirebaseAuth.instance.currentUser?.uid;

  String _name(BuildContext context, Message message) {
    if (_isOwn(message)) return 'Replying to yourself';
    final name = context.read<ChatsNotifier>().currentChat?.username;
    return name == null || name.isEmpty ? 'Replying' : 'Replying to $name';
  }
}
