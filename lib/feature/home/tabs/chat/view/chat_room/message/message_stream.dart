import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/utils.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/state/chats_notifier.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/current_chat.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/message.dart';

import '../../../../../../../common/components/components.dart';
import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../constants/index.dart';
import 'message_bubble.dart';

class MessageStream extends StatefulWidget {
  const MessageStream({super.key, required this.scrollController});

  final ScrollController scrollController;

  @override
  State<MessageStream> createState() => _MessageStreamState();
}

class _MessageStreamState extends State<MessageStream> {
  late Stream<List<Message>> messagesStream;
  late ChatsNotifier _chatsNotifier;
  final currentUser = FirebaseAuth.instance.currentUser!.uid;
  int messageLimit = 30;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);

    _chatsNotifier = context.read<ChatsNotifier>();

    // Initialize the stream in initState
    messagesStream = _chatsNotifier.messagesStream(messageLimit);
  }

  void _onScroll() {
    final scroll = widget.scrollController;

    if (scroll.position.atEdge &&
        scroll.position.pixels != 0 &&
        scroll.position.userScrollDirection == ScrollDirection.reverse) {
      setState(() {
        messageLimit += 20;
        messagesStream = _chatsNotifier.messagesStream(messageLimit);
      });
    }
  }

  @override
  void dispose() {
    // Remove the scroll listener to avoid memory leaks
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ChatsNotifier, CurrentChat?>(
      selector: (context, chatsNotifier) => chatsNotifier.currentChat,
      builder: (context, currentChat, child) {
        return StreamBuilder<List<Message>>(
          stream: messagesStream,
          builder: (context, snapshot) {
            return AppAnimatedSwitcher(
              child: _buildMessageStream(snapshot, currentChat),
            );
          },
        );
      },
    );
  }

  Widget _buildMessageStream(
    AsyncSnapshot<List<Message>> snapshot,
    CurrentChat? currentChat,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const AppLoader(
        key: ValueKey('loading'),
        color: Colors.black,
      );
    }

    if (snapshot.hasError) {
      return const Text('Sorry, try again later');
    }

    if (snapshot.hasData) {
      List<Message> messages = snapshot.data!;

      if (messages.isEmpty) {
        return const EmptyDataBox(
          key: ValueKey('empty'),
          image: AppAssets.noMessages,
          text: 'No messages yet',
        );
      }

      final earliestMessage = messages.last;
      final formattedDate = earliestMessage.timestamp != null
          ? 'on ${earliestMessage.timestamp!.toTimestamp()?.toDate().formatWithSuffix()}'
          : 'now';

      return ListView.builder(
        key: const ValueKey('data'),
        reverse: true,
        controller: widget.scrollController,
        itemCount: messages.length,
        shrinkWrap: true,
        itemBuilder: (ctx, idx) {
          final message = messages[idx];
          final isFirstMessage = idx == messages.length - 1;

          final isPreviousSameSender = (idx < messages.length - 1) &&
              messages[idx + 1].senderId == message.senderId;

          final isNextSameSender =
              (idx > 0) && messages[idx - 1].senderId == message.senderId;

          // Determine if a date separator is needed
          final currentMessageDate =
              message.timestamp?.toDateTime()?.toLocal() ?? DateTime.now();
          DateTime? previousMessageDate;

          if (idx < messages.length - 1) {
            previousMessageDate =
                messages[idx + 1].timestamp?.toDateTime()?.toLocal();
          }

          // Check if the current message needs a date separator
          bool showDateSeparator = false;
          String dateLabel = "";

          if (previousMessageDate == null ||
              currentMessageDate.day != previousMessageDate.day ||
              currentMessageDate.month != previousMessageDate.month ||
              currentMessageDate.year != previousMessageDate.year) {
            showDateSeparator = true;
            final now = DateTime.now();
            final yesterday = now.subtract(const Duration(days: 1));

            if (currentMessageDate.year == now.year &&
                currentMessageDate.month == now.month &&
                currentMessageDate.day == now.day) {
              dateLabel = "Today";
            } else if (currentMessageDate.year == yesterday.year &&
                currentMessageDate.month == yesterday.month &&
                currentMessageDate.day == yesterday.day) {
              dateLabel = "Yesterday";
            } else {
              dateLabel =
                  "${currentMessageDate.monthName} ${currentMessageDate.day}${_getOrdinal(currentMessageDate.day)}";
            }
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isFirstMessage) ...[
                addHeight(12),
                Text(
                  "Conversation started $formattedDate",
                  style: TextStyles.chatText,
                ),
                addHeight(14),
              ],
              if (showDateSeparator && !isFirstMessage) ...[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 6.r),
                  padding: EdgeInsets.symmetric(
                    vertical: 6.r,
                    horizontal: 8.r,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.listTileColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    dateLabel,
                    style: TextStyles.chatText.copyWith(
                      fontSize: AppUtils.scale(9.sp) ?? 11.5.sp,
                    ),
                  ),
                ),
              ],
              MessageBubble(
                key: ValueKey(message.id),
                isSender: currentUser == message.senderId,
                data: message,
                url: currentChat?.profilePicUrl,
                isPreviousSameSender: isPreviousSameSender,
                isNextSameSender: isNextSameSender,
              ),
            ],
          );
        },
      );
    }

    return const Center(child: Text('No data available'));
  }
}

String _getOrdinal(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}
