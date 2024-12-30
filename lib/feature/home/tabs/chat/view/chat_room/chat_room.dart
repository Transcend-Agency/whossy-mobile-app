import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/chat/model/chat_room_data.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/chat_room/chat_room_blur.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/services/services.dart';
import '../../../../../../constants/index.dart';
import '../widgets/_.dart';
import '../widgets/sheets/actions_sheet.dart';
import '../widgets/sheets/photo_sheet.dart';
import 'message/message_image_view.dart';

part 'chat_room_helpers.dart';

@RoutePage()
class ChatRoom extends StatefulWidget {
  const ChatRoom({super.key});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final _picker = ImagePicker();

  late ChatsNotifier _chatsNotifier;
  late bool isPrevOpened;

  final messagesController = TextEditingController();
  final scrollController = ScrollController();
  final messagesFocusNode = FocusNode();

  bool showIcon = false;
  bool typing = false;

  bool isTab = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenWidth = MediaQuery.of(context).size.width;

    // Check if the value has changed before updating state
    if (screenWidth > 500 != isTab) {
      setState(() {
        isTab = screenWidth > 500;
      });
    }
  }

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

  void _scrollToBottomIcon() {
    scrollController.addListener(() {
      if (scrollController.offset > 30) {
        setState(() => showIcon = true);
      } else {
        setState(() => showIcon = false);
      }
    });
  }

  Future<bool> _handlePermissions({Picture? pic}) async {
    return await FileService.handlePermissions(
      context: context,
      showDialog: showSettingsDialog,
      showSnackbar: (message) => showSnackbar(message, context),
      pic: pic,
      onAddPhoto: _addPhoto,
    );
  }

  Future<bool> _addPhoto({Picture? pic}) async {
    bool result = false;

    try {
      XFile? pickedImage;

      // Pick a single image based on the source
      if (pic == Picture.gallery) {
        pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      } else if (pic == Picture.photo) {
        pickedImage = await _picker.pickImage(source: ImageSource.camera);
      }

      // Proceed if an image was picked and the widget is mounted
      if (mounted && pickedImage != null) {
        Nav.push(
          context,
          ImagePreview(
            images: [pickedImage], // Pass the single picked image as a list
            text: messagesController.text.trim().isNotEmpty
                ? messagesController.text.trim()
                : null,
          ),
        );
      }
    } catch (e) {
      // Log the error and rethrow for further handling
      log('Error picking image: $e');
      rethrow;
    }

    return result; // Return true if needed for further logic
  }

  void onAddPhoto() async {
    Picture? result = await showAddPhotoSheet(context);

    if (result == null) return;

    await _handlePermissions(pic: result);
  }

  @override
  void initState() {
    super.initState();

    _chatsNotifier = context.read<ChatsNotifier>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () async {
        isPrevOpened = _chatsNotifier.hasChatOpened;

        if (!isPrevOpened) {
          await openDialog(context);

          _chatsNotifier.hasChatOpened = true;
        }
      });
    });

    messagesController.addListener(_updateIcon);

    _chatsNotifier.listenToChatUpdates();

    _scrollToBottomIcon();
  }

  @override
  void dispose() {
    messagesFocusNode.dispose();
    scrollController.dispose();
    messagesController.dispose();

    _chatsNotifier.cancelChatUpdates();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<ChatsNotifier, ChatRoomData>(
      selector: (_, chats) => ChatRoomData(
        currentChat: chats.currentChat!,
        currentUserName: chats.userData?.firstName ?? '',
        hasViewPermission: chats.viewPermission,
      ),
      builder: (_, data, __) {
        return AppScaffold(
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar(
            addBarHeight: 4,
            titleWidget: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      TransparentRoute(
                        builder: (context) => MessageImageView(
                            imageUrl: data.currentChat.profilePicUrl),
                      ),
                    );
                  },
                  child: CircleAppAvatar(
                    imageUrl: data.currentChat.profilePicUrl,
                    radius: isTab ? 20 : 22.r,
                  ),
                ),
                addWidth(isTab ? 10 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.currentChat.username,
                        style: TextStyles.profileHead,
                      ),
                      addHeight(1),
                      OnlineStatus(oppUserId: data.currentChat.uidUser2),
                    ],
                  ),
                ),
              ],
            ),
            color: Colors.white,
            action: Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: AppIconButton(
                onTap: () => showActionsSheet(context, data: data),
                icon: Icons.more_horiz_rounded,
              ),
            ),
          ),
          body: Stack(
            children: [
              if (data.hasViewPermission)
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
                            right: 10,
                            child: ChatScrollButton(
                              showIcon: showIcon,
                              onPressed: _scrollToBottom,
                            ),
                          )
                        ],
                      ),
                    ),
                    Selector<EditProfileNotifier, List<String>>(
                      selector: (_, edit) => edit.coreProfile?.blockedIds ?? [],
                      builder: (_, blockedIds, __) {
                        return blockedIds.contains(data.currentChat.uidUser2)
                            ? GestureDetector(
                                onTap: unblockUser,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  height: 50.r,
                                  width: double.infinity,
                                  color: AppColors.inputBackGround
                                      .withOpacity(0.9),
                                  child: Center(
                                    child: Text(
                                      'UNBLOCK',
                                      style: TextStyles.chatText.copyWith(
                                        fontSize:
                                            AppUtils.scale(11.5.sp) ?? 13.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: chatFieldPadding,
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: onAddPhoto,
                                      child: Padding(
                                        padding: EdgeInsets.all(4.r)
                                            .copyWith(right: 10),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 22.r,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

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
                                                onPrefixIconTap: onAddPhoto,
                                                isReplying: false,
                                              ),
                                            ),
                                          ), //
                                        ],
                                      ),
                                    ),

                                    addWidth(6),

                                    // Record audio / Send message button
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                          onTap: typing ? sendMessage : null,
                                          child: CircleAvatar(
                                            radius: 21,
                                            backgroundColor: Colors.white,
                                            child: typing
                                                ? sendIcon()
                                                : voiceIcon(),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                      },
                    ),
                  ], //
                ),
              const ChatRoomBlur(),
            ],
          ),
        );
      },
    );
  }

  Future<void> unblockUser() async {
    final editNotifier = context.read<EditProfileNotifier>();
    var blockedIds = editNotifier.coreProfile?.blockedIds ?? [];
    var originalBlockedIds = List<String>.from(blockedIds);

    blockedIds.remove(_chatsNotifier.currentChat!.uidUser2);
    editNotifier.updateProfile(blockedIds: blockedIds);

    bool success = await editNotifier.saveUserProfile(
      showSnackbar: (msg) => showSnackbar(msg, context),
    );

    if (!success) {
      editNotifier.updateProfile(blockedIds: originalBlockedIds);
    }
  }
}
