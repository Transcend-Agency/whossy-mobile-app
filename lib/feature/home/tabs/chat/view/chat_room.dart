import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/widgets/online_status.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/widgets/sheets/actions_sheet.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/widgets/sheets/photo_sheet.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../common/styles/component_style.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';
import '../model/current_chat.dart';
import 'widgets/message_stream.dart';
import 'widgets/scroll_button.dart';

@RoutePage()
class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  late ChatsNotifier _chatsNotifier;
  late bool isPrevOpened;

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

  void sendMessage() {
    _scrollToBottom();

    _chatsNotifier.sendMessage(messagesController.text.trim());

    messagesController.clear();
  }

  openDialog() async {
    await showConfirmationDialog(
      yes: 'Continue',
      headerImage: Padding(
        padding: EdgeInsets.only(bottom: 6.h),
        child: Image.asset(
          AppAssets.shield,
          height: 120,
        ),
      ),
      context,
      title: 'Chat safety is a priority',
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: AppStrings.chatSafety,
            style: TextStyles.bioText.copyWith(
              fontSize: AppUtils.scale(11.sp),
            ),
          ),
          TextSpan(
            text: "Safety guide",
            style: TextStyles.bioText.copyWith(
              fontSize: AppUtils.scale(11.sp),
              decoration: TextDecoration.underline,
            ),
          ),
          TextSpan(
            text: " and ",
            style: TextStyles.bioText.copyWith(
              fontSize: AppUtils.scale(11.sp),
            ),
          ),
          TextSpan(
            text: "Privacy policies",
            style: TextStyles.bioText.copyWith(
              fontSize: AppUtils.scale(11.sp),
              decoration: TextDecoration.underline,
            ),
          ),
        ]),
      ),
    );
  }

// AppStrings.chatSafety,
  @override
  void initState() {
    super.initState();

    _chatsNotifier = context.read<ChatsNotifier>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () async {
        isPrevOpened = _chatsNotifier.hasChatOpened;

        if (!isPrevOpened) {
          await openDialog();

          _chatsNotifier.hasChatOpened = true;
        }
      });
    });

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
    return Selector<ChatsNotifier, CurrentChat>(
      selector: (_, chats) => chats.currentChat!,
      builder: (_, currentChat, __) {
        return AppScaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            addBarHeight: 10,
            titleWidget: Row(
              children: [
                AppAvatar(imageUrl: currentChat.profilePicUrl, radius: 20),
                addWidth(10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentChat.username,
                        style: TextStyles.profileHead,
                      ),
                      addHeight(1),
                      OnlineStatus(userId: currentChat.uidUser2),
                    ],
                  ),
                ),
              ],
            ),
            color: Colors.white,
            action: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: AppIconButton(
                onTap: () => showActionsSheet(context, currentChat.username),
                icon: Icons.more_horiz_rounded,
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
                                    onPrefixIconTap: () =>
                                        showAddPhotoSheet(context),
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
                            // GestureDetector(
                            //   onTap: () {},
                            //   child: CircleAvatar(
                            //     radius: 21,
                            //     backgroundColor: Colors.white,
                            //     child: svgIcon(AppAssets.gift, color: Colors.black),
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: typing ? sendMessage : null,
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
      },
    );
  }
}
