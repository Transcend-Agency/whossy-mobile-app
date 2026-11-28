import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:whossy_app/common/components/components.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/utils.dart';
import 'package:whossy_app/provider/provider.dart';

import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../constants/index.dart';
import '../../../model/message.dart';
import 'message_details.dart';
import 'message_image_grid.dart';
import 'reply_quote.dart';
import 'swipe_to_reply.dart';

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
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  // Map to track upload states for local photos
  late Map<String, bool> uploadStates;

  late ChatsNotifier _chatNotifier;

  @override
  void initState() {
    super.initState();

    _chatNotifier = context.read<ChatsNotifier>();

    // Initialize upload states as a map
    uploadStates = {
      if (widget.data.localPhoto != null) widget.data.localPhoto!: false,
    };

    _checkAndUploadFiles();
  }

  Future<void> markAsSeen() async {
    if (context.mounted) {
      await _chatNotifier.updateMessageStatus(widget.data);
    }
  }

  void updateMessageStatus(VisibilityInfo info) {
    if (info.visibleFraction > 0.3 &&
        widget.data.senderId != currentUser &&
        widget.data.status != MessageStatus.seen) {
      markAsSeen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageStyle = TextStyles.messageText(
      context.select<ChatTextSizeNotifier, double>((n) => n.fontSize),
    );
    final recipientDeliveredAt = context.select<ChatsNotifier, Timestamp?>(
      (n) => n.recipientDeliveredAt,
    );

    final reply = widget.data.replyTo;

    return VisibilityDetector(
      onVisibilityChanged: updateMessageStatus,
      key: ValueKey(widget.data.id),
      child: SwipeToReply(
        onReply: _startReply,
        child: Align(
          alignment: widget.isSender ? Alignment.topRight : Alignment.topLeft,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!widget.isSender && !widget.isPreviousSameSender) ...[
                addWidth(10),
                CircleAppAvatar(imageUrl: widget.url, radius: 17)
              ] else if (!widget.isSender) ...[
                addWidth(10),
                hide(
                  child: CircleAppAvatar(imageUrl: widget.url, radius: 17),
                ),
              ],
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: widget.isSender
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onLongPress: _showActions,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
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
                      child: (widget.data.localPhoto?.isNotEmpty ?? false) ||
                              (widget.data.photo?.isNotEmpty ?? false) ||
                              (widget.data.message != null)
                          ? Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.sizeOf(context).width * 0.75,
                              ),
                              child: _fitToQuote(Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: widget.isSender
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  // The message this one replies to.
                                  if (reply != null) ...[
                                    ReplyQuote(
                                      key: const ValueKey('reply_quote'),
                                      name: reply.senderId == currentUser
                                          ? 'You'
                                          : _chatNotifier
                                                  .currentChat?.username ??
                                              '',
                                      preview: reply.preview,
                                      isOwn: reply.senderId == currentUser,
                                      fontSize: messageStyle.fontSize!,
                                    ),
                                    const SizedBox(height: 6),
                                  ],
                                  // Image Grid Section (if any photos exist)
                                  if ((widget.data.localPhoto?.isNotEmpty ??
                                          false) ||
                                      (widget.data.photo?.isNotEmpty ?? false))
                                    Container(
                                      constraints: BoxConstraints(
                                        maxHeight: 270,
                                        maxWidth:
                                            MediaQuery.sizeOf(context).width *
                                                0.75,
                                      ),
                                      child: ImageGrid(
                                        localPhotos:
                                            widget.data.localPhoto != null &&
                                                    widget.data.localPhoto!
                                                        .isNotEmpty
                                                ? [widget.data.localPhoto!]
                                                : [],
                                        photos: widget.data.photo != null &&
                                                widget.data.photo!.isNotEmpty
                                            ? [widget.data.photo!]
                                            : [],
                                        messageId: widget.data.id,
                                      ),
                                    ),

                                  if (((widget.data.localPhoto?.isNotEmpty ??
                                              false) ||
                                          (widget.data.photo?.isNotEmpty ??
                                              false)) &&
                                      widget.data.message != null)
                                    addHeight(6),
                                  // Message Section (if a message exists)
                                  if (widget.data.message != null &&
                                      widget.data.message!.isNotEmpty)
                                    ReadMoreText(
                                      widget.data.message!,
                                      trimLines: 5,
                                      trimMode: TrimMode.Line,
                                      textAlign: TextAlign.left,
                                      trimExpandedText: ' show less',
                                      style: messageStyle,
                                      moreStyle: messageStyle.copyWith(
                                        color: AppColors.messageMetaColor,
                                      ),
                                      lessStyle: messageStyle.copyWith(
                                        color: AppColors.messageMetaColor,
                                      ),
                                    ),
                                ],
                              )),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w + 4.r),
                    child: MessageDetails(
                      time: widget.data.timestamp?.toTimestamp(),
                      tick: widget.data.senderId == currentUser
                          ? _chatNotifier.tickState(
                              widget.data.status,
                              widget.data.timestamp?.toTimestamp(),
                              recipientDeliveredAt,
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A reply's bubble is as wide as its widest part, so the quote spans the
  /// whole bubble instead of only its own text.
  Widget _fitToQuote(Widget content) =>
      widget.data.replyTo == null ? content : IntrinsicWidth(child: content);

  void _startReply() {
    _chatNotifier.startReply(widget.data);
  }

  Future<void> _showActions() async {
    HapticFeedback.mediumImpact();
    final text = widget.data.message;

    final action = await showModalBottomSheet<String>(
      context: context,
      shape: roundedTop,
      clipBehavior: Clip.hardEdge,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              key: const ValueKey('message_action_reply'),
              leading: const Icon(Icons.reply_rounded),
              title: const Text('Reply'),
              onTap: () => Navigator.pop(sheetContext, 'reply'),
            ),
            if (text != null && text.isNotEmpty)
              ListTile(
                key: const ValueKey('message_action_copy'),
                leading: const Icon(Icons.copy_rounded),
                title: const Text('Copy text'),
                onTap: () => Navigator.pop(sheetContext, 'copy'),
              ),
          ],
        ),
      ),
    );

    if (!mounted) return;
    switch (action) {
      case 'reply':
        _startReply();
      case 'copy':
        await Clipboard.setData(ClipboardData(text: text!));
        if (mounted) {
          showSnackbar('Copied', context, snackBarType: SnackbarType.success);
        }
    }
  }

  void onUploadComplete(bool success, String localPath) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) setState(() => uploadStates[localPath] = success);
    });
  }

  void _checkAndUploadFiles() {
    // Check if localPhoto is not null and is not empty
    if (widget.data.localPhoto != null && widget.data.localPhoto!.isNotEmpty) {
      // If localPhoto is a single string, treat it as a key, else iterate over the keys
      final photoPaths = [widget.data.localPhoto!];

      for (var localPhotoPath in photoPaths) {
        // Trigger upload if not already uploading
        if (!(uploadStates[localPhotoPath] ?? false)) {
          uploadStates[localPhotoPath] = true;

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _chatNotifier.uploadFiles(
              id: widget.data.id,
              localPhotoPaths: [localPhotoPath],
              onUploadComplete: (s) => onUploadComplete(s, localPhotoPath),
            );
          });
        }
      }
    }
  }
}
