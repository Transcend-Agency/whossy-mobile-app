import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../provider/provider.dart';
import '../../model/chat_credit_state.dart';

/// Slim status strip above the composer describing the Reply-Gated Credits
/// state (spec §1.2). Renders nothing when there's nothing to say — the
/// not-matched and broke-and-empty cases are handled by [ChatRoomBlur].
class ChatStateBanner extends StatelessWidget {
  const ChatStateBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatsNotifier>(
      builder: (_, chats, __) {
        final state = chats.creditState;
        final name = chats.currentChat?.username ?? 'them';
        final premium = chats.userData?.premiumUser ?? false;
        final broke = !(chats.userData?.canInitiateChat ?? false);
        final subChat = chats.subChat;

        String text;
        Color background = const Color(0xFFF6F6F6);
        Color foreground = const Color(0xFF5D5D5D);

        switch (state) {
          case ChatCreditState.idle:
            text = broke
                ? 'You need 1 credit or Premium to chat with $name — credits '
                    'are only charged when they reply.'
                : premium
                    ? 'Send a message to start the chat with $name.'
                    : 'Send a message to start. 1 credit will be held and '
                        'only charged when $name replies.';
          case ChatCreditState.pendingInitiator:
            if (subChat?.creditHeld ?? false) {
              final left = hoursLeftFrom(subChat?.holdPlacedAt);
              text = '1 credit on hold · charged only when $name replies · '
                  'returned in ${left}h if they don\'t';
            } else {
              text = 'Waiting for $name to reply.';
            }
            background = const Color(0xFFFFF7E6);
            foreground = const Color(0xFF8A6D1A);
          case ChatCreditState.pendingRecipient:
            text = '$name started a chat with you — replying is free and '
                'connects you two.';
            background = const Color(0xFFEAF7EF);
            foreground = const Color(0xFF1D7A45);
          case ChatCreditState.connected:
            final left = hoursUntil(subChat?.expirationTime);
            text = 'Connected · free chat for ${left}h more';
            background = const Color(0xFFEAF7EF);
            foreground = const Color(0xFF1D7A45);
          case ChatCreditState.expired:
            text = broke
                ? 'Your 48-hour window has ended. You need 1 credit or '
                    'Premium to reconnect — only charged when $name replies.'
                : premium
                    ? 'Your 48-hour window has ended. Send a message to '
                        'reconnect.'
                    : 'Your 48-hour window has ended. Send a message to '
                        'reconnect — 1 credit, held until they reply.';
        }

        return Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 6.h),
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyles.hintText.copyWith(
              fontSize: 12.sp,
              color: foreground,
              height: 1.35,
            ),
          ),
        );
      },
    );
  }
}
