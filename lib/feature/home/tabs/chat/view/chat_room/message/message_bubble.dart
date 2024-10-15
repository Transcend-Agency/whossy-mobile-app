import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/index.dart';
import 'package:whossy_app/feature/home/tabs/chat/view/chat_room/message/message_details.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../constants/index.dart';
import '../../../model/message.dart';
import 'message_image_grid.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble({
    super.key,
    required this.data,
    required this.isSender,
    this.url,
    required this.isPreviousSameSender,
    required this.isNextSameSender,
  });

  final Message data;
  final bool isSender;
  final String? url;
  final bool isPreviousSameSender;
  final bool isNextSameSender;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  double _slideOffset = 0.0;
  // Map to track upload states for local photos
  late Map<String, bool> uploadStates;
  static final double _dragThreshold = -86.r;
  static final double _revealThreshold = -72.r;

  late ChatsNotifier _chatNotifier;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _chatNotifier = context.read<ChatsNotifier>();

    _checkAndUploadFiles();

    // Initialize upload states as a map
    uploadStates = {
      for (var photo in widget.data.localPhotos ?? []) photo: false,
    };
  }

  void _animateBackToPosition(DragEndDetails details) {
    _animation = Tween<double>(begin: _slideOffset, end: 0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    )..addListener(() => setState(() => _slideOffset = _animation.value));

    _animationController.forward(from: 0);
  }

  void _updateSlideOffset(DragUpdateDetails details) {
    setState(() {
      _slideOffset += details.delta.dx;
      if (_slideOffset > 0) _slideOffset = 0; // Prevent sliding right
      if (_slideOffset < _dragThreshold) {
        _slideOffset = _dragThreshold; // Limit sliding distance
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onUploadComplete(bool success, String localPath) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => uploadStates[localPath] = success);
    });
  }

  void _checkAndUploadFiles() {
    if (widget.data.localPhotos?.isNotEmpty ?? false) {
      for (var localPhotoPath in widget.data.localPhotos ?? []) {
        // Trigger upload if not already uploading
        if (!uploadStates[localPhotoPath]!) {
          uploadStates[localPhotoPath] = true; // Set to uploading

          log(' \n \n -------- Trigger uploading -------- \n \n');

          _chatNotifier.uploadFiles(
            id: widget.data.id,
            localPhotoPaths: [localPhotoPath],
            onUploadComplete: (s) => onUploadComplete(s, localPhotoPath),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragUpdate: _updateSlideOffset,
      onHorizontalDragEnd: _animateBackToPosition,
      child: Stack(
        children: [
          Positioned(
            right: _revealThreshold - _slideOffset,
            top: 0,
            bottom: 0,
            child: MessageDetails(
              status: widget.data.status,
              time: widget.data.timestamp,
            ),
          ),

          // The message bubble
          Transform.translate(
            offset: Offset(_slideOffset, 0),
            child: Align(
              alignment:
                  widget.isSender ? Alignment.topRight : Alignment.topLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!widget.isSender && !widget.isPreviousSameSender) ...[
                    addWidth(10),
                    AppAvatar(imageUrl: widget.url, radius: 17)
                  ] else if (!widget.isSender) ...[
                    addWidth(10),
                    hide(
                      child: AppAvatar(imageUrl: widget.url, radius: 17),
                    ),
                  ],
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 6.r,
                      horizontal: 8.r,
                    ),
                    margin: EdgeInsets.symmetric(vertical: 2, horizontal: 10.w),
                    decoration: bubbleDecoration(
                      widget.isSender,
                      widget.isPreviousSameSender,
                      widget.isNextSameSender,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.sizeOf(context).width * .75,
                    ),
                    child: (widget.data.localPhotos?.isNotEmpty ?? false) ||
                            (widget.data.photos?.isNotEmpty ?? false)
                        ? Container(
                            constraints: BoxConstraints(
                              maxHeight: 270,
                              maxWidth: MediaQuery.sizeOf(context).width * 0.75,
                            ),
                            child: ImageGrid(
                              localPhotos: widget.data.localPhotos,
                              photos: widget.data.photos,
                              uploadStates: uploadStates.values.toList(),
                              messageId: widget.data.id,
                            ),
                          )
                        : ReadMoreText(
                            widget.data.message,
                            trimLines: 2,
                            trimMode: TrimMode.Line,
                            textAlign: TextAlign.left,
                            trimExpandedText: ' show less',
                            style: TextStyles.chatText.copyWith(),
                            moreStyle: TextStyles.chatText.copyWith(
                              color: AppColors.hintTextColor,
                            ),
                            lessStyle: TextStyles.chatText.copyWith(
                              color: AppColors.hintTextColor,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
