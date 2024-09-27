import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/components/index.dart';

import '../../../../../common/styles/component_style.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import 'widgets/message_stream.dart';
import 'widgets/scroll_button.dart';

@RoutePage()
class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final messagesController = TextEditingController();
  final scrollController = ScrollController();
  final messagesFocusNode = FocusNode();

  bool showIcon = false;
  bool typing = false;

  void _scrollToBottom() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController
            .animateTo(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn)
            .then((value) {
          if (scrollController.offset > 20) {
            // If not close to the bottom, trigger the function
            _scrollToBottom();
          }
        });
      }
    });
  }

  void _updateIcon() {
    if (messagesController.text.isNotEmpty) {
      setState(() => typing = true);
    } else {
      setState(() => typing = false);
    }
  }

  @override
  void initState() {
    super.initState();

    messagesController.addListener(_updateIcon);
  }

  @override
  void dispose() {
    messagesFocusNode.dispose();
    scrollController.dispose();
    messagesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        titleWidget: Row(
          children: [
            // ProfileAvatar(imageUrl: currentChat.profilePicUrl),
            addWidth(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bamidele',
                    style: TextStyles.profileHead.copyWith(
                      fontSize: AppUtils.scale(16.sp),
                    ),
                  ),
                  addHeight(2),
                  Text(
                    'Online',
                    style: TextStyles.prefText.copyWith(
                      color: AppColors.hintTextColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        color: Colors.white,
        action: Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: GestureDetector(
            onTap: () {},
            child: CircleAvatar(
              radius: 21,
              backgroundColor: Colors.white,
              child: moreIcon(),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    MessageStream(
                      scrollController: scrollController,
                    ),
                    Positioned(
                      bottom: 10,
                      right: 20,
                      child: ChatScrollButton(
                        showIcon: showIcon,
                        onPressed: _scrollToBottom,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: chatFieldPadding,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 5 * 16 * 1.4,
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: MessageTextField(
                                node: messagesFocusNode,
                                controller: messagesController,
                                onPrefixIconTap: () {},
                                isReplying: false,
                              ),
                            ),
                          ), //
                        ],
                      ),
                    ),

                    // Some horizontal spacing
                    addWidth(6),

                    // Record audio / Send message button
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 21,
                            backgroundColor: Colors.white,
                            child: svgIcon(AppAssets.gift, color: Colors.black),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 21,
                            backgroundColor: Colors.white,
                            child: typing ? sendIcon() : voiceIcon(),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
