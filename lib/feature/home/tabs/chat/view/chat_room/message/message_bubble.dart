import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
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

//
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

//
class _MessageBubbleState extends State<MessageBubble>
    with SingleTickerProviderStateMixin {
  double _slideOffset = 0.0;
  static final double _dragThreshold = -90.r;
  static final double _revealThreshold = -72.r;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
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

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatsNotifier>(
      builder: (context, chatNotifier, child) {
        // Check if there are local photos available
        if (widget.data.localPhotos?.isNotEmpty ?? false) {
          final localPhotoPath = widget.data.localPhotos![0];

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!chatNotifier.isUploading && !chatNotifier.hasUploadFailed) {
              chatNotifier.uploadFile(
                id: widget.data.id,
                localPhotoPath: localPhotoPath,
              );
            }
          });
        }

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
                child: MessageDetails(message: widget.data),
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
                            child: AppAvatar(imageUrl: widget.url, radius: 17)),
                      ],
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 6.r,
                          horizontal: 8.r,
                        ),
                        margin:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 10.w),
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
                                  maxHeight: 300,
                                  maxWidth:
                                      MediaQuery.sizeOf(context).width * 0.75,
                                ),
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    if (widget.data.localPhotos != null &&
                                        widget.data.localPhotos!.isNotEmpty)
                                      _localImage(
                                        chatNotifier.isUploading,
                                        chatNotifier.hasUploadFailed,
                                      )
                                    else if (widget.data.photos != null &&
                                        widget.data.photos!.isNotEmpty)
                                      _networkImage(),
                                  ],
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
      },
    );
  }

  Widget _localImage(bool isUploading, bool hasUploadFailed) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              showImage(
                widget.data.localPhotos![0],
                fit: BoxFit.cover,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
                child: Container(color: Colors.transparent),
              ),
            ],
          ),
        ),

        // Show loader if uploading
        if (isUploading)
          const Align(
            alignment: Alignment.center,
            child: AppLoader(),
          ),

        // Show retry button if upload failed
        if (hasUploadFailed)
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.red),
              onPressed: () {
                context
                    .read<ChatsNotifier>()
                    .retryUpload(widget.data.id, widget.data.localPhotos![0]);
              },
            ),
          ),
      ],
    );
  }

  Widget _networkImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: editMediaDecoration,
        child: CachedNetworkImage(
          imageUrl: widget.data.photos![0],
          imageBuilder: (_, imageProvider) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
          placeholder: (_, __) => const ShimmerWidget.rectangular(),
          errorWidget: (context, url, error) {
            // Log the error message
            log('Error loading image: ${error.toString()}');

            // Return your offline widget or any error widget
            return offline(); // Replace with your error widget as needed
          },
        ),
      ),
    );
  }
}
