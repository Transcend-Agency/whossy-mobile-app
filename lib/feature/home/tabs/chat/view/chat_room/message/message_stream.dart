import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/index.dart';
import 'package:whossy_app/feature/home/tabs/chat/data/state/chats_notifier.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/current_chat.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/message.dart';

import '../../../../../../../common/components/index.dart';
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

    // Check if the user has reached the end of the list by scrolling up
    if (scroll.position.atEdge &&
        scroll.position.pixels != 0 &&
        scroll.position.userScrollDirection == ScrollDirection.reverse) {
      // Increase the limit but avoid re-creating the stream multiple times.
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
      return const AppLoader(color: Colors.black);
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
          ? 'on ${DateFormat('d/M/yyyy').format(earliestMessage.timestamp!.toDate())}'
          : 'now';

      return ListView.builder(
        reverse: true,
        controller: widget.scrollController,
        itemCount: messages.length,
        shrinkWrap: true,
        itemBuilder: (ctx, idx) {
          final message = messages[idx];
          final isFirstMessage = idx == messages.length - 1;

          // Check if the next message (index + 1) exists and has the same sender
          final isPreviousSameSender = (idx < messages.length - 1) &&
              messages[idx + 1].senderId == message.senderId;

          // Check if the previous message (index - 1) exists and has the same sender
          final isNextSameSender =
              (idx > 0) && messages[idx - 1].senderId == message.senderId;

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