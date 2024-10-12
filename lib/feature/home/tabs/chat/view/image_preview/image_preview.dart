import 'dart:io';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';

import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../provider/providers.dart';

part 'image_preview_helpers.dart';

@RoutePage()
class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.images,
    required this.text,
  });

  final List<XFile> images;
  final String? text;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late List<XFile> _images; // Use a separate list for images
  late ChatsNotifier _chatsNotifier;
  final _controller = PageController();
  final messagesFocusNode = FocusNode();
  final messagesController = TextEditingController();

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();

    _chatsNotifier = context.read<ChatsNotifier>();

    // Initialize the images list
    _images = List.from(widget.images);

    // Preload text if available
    if (widget.text != null) {
      messagesController.text = widget.text!;
    }

    // Listen to page changes
    _controller.addListener(() {
      setState(() => _currentPageIndex = _controller.page?.round() ?? 0);
    });
  }

  void _deleteCurrentImage() {
    if (_images.isNotEmpty) {
      setState(() {
        _images.removeAt(_currentPageIndex);

        // Adjust the current page index if necessary
        if (_currentPageIndex >= _images.length) {
          _currentPageIndex = _images.length - 1;
        }

        // Check if there are no more images left
        if (_images.isEmpty) {
          Navigator.pop(context);
        } else {
          _controller.jumpToPage(_currentPageIndex);
        }
      });
    }
  }

  void sendMessage() {
    _chatsNotifier.sendMessage(
      messagesController.text.trim(),
      pictures: _images,
    );

    Navigator.pop(context);

    messagesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        addBarHeight: 4,
        color: Colors.white,
        title: '',
        action: Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: AppIconButton(
            onTap: _deleteCurrentImage,
            icon: Icons.delete,
          ),
        ),
      ),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Container(
            padding: pagePadding,
            constraints: const BoxConstraints.expand(),
            child: PageView.builder(
              controller: _controller,
              itemCount: _images.length,
              itemBuilder: (_, index) {
                return showImage(_images[index].path);
              },
            ),
          ),
          Positioned(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width,
              ),
              child: Padding(
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
                          ),
                        ],
                      ),
                    ),

                    // Some horizontal spacing
                    addWidth(6),

                    // Record audio / Send message button
                    GestureDetector(
                      onTap: sendMessage,
                      child: CircleAvatar(
                        radius: 21,
                        backgroundColor: Colors.white,
                        child: sendIcon(),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 70.h,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width,
              ),
              child: PreviewPageIndicator(
                images: _images, // Pass the updated images list
                currentPageIndex: _currentPageIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the focus nodes and controllers
    messagesFocusNode.dispose();
    messagesController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
