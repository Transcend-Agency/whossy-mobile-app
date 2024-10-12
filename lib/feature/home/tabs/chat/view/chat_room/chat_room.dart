import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/services/services.dart';
import '../../../../../../constants/index.dart';
import '../../model/current_chat.dart';
import '../widgets/_.dart';
import '../widgets/sheets/actions_sheet.dart';
import '../widgets/sheets/photo_sheet.dart';

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
    List<XFile> pickedImages = [];

    try {
      if (pic == Picture.gallery) {
        // pickMultiImage returns List<XFile>
        pickedImages = await _picker.pickMultiImage();
      } else if (pic == Picture.photo) {
        // pickImage returns a single XFile, so we convert it to a list
        final image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          pickedImages = [image];
        }
      }

      if (mounted && pickedImages.isNotEmpty) {
        Nav.push(
          context,
          ImagePreview(
            images: pickedImages,
            text: messagesController.text.trim().isNotEmpty
                ? messagesController.text.trim()
                : null,
          ),
        );
      }

      // for (var file in pickedImages) {
      //   final croppedImage = await FileService.cropImage(File(file.path));
      //
      //   if (croppedImage != null) {
      //     setState(() {});
      //   }
      // }
    } catch (e) {
      // Throw an error if permission is denied
      log('Error picking image: $e');
      rethrow;
    }

    return result; // Return true if re-uploading succeeded, otherwise false
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
      Future.delayed(const Duration(milliseconds: 500), () async {
        isPrevOpened = _chatsNotifier.hasChatOpened;

        if (!isPrevOpened) {
          await openDialog(context);

          _chatsNotifier.hasChatOpened = true;
        }
      });
    });

    messagesController.addListener(_updateIcon);

    _scrollToBottomIcon();
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
            addBarHeight: 4,
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
                          right: 10,
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
                                    onPrefixIconTap: onAddPhoto,
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
