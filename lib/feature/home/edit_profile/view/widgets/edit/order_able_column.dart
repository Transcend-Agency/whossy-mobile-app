import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/services/file_service.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../provider/providers.dart';
import '../../../../../auth/onboarding/view/edit_sheet.dart';
import 'image_view.dart';

class OrderAbleColumn extends StatefulWidget {
  const OrderAbleColumn({
    super.key,
    required this.profilePics,
  });

  final List<String> profilePics;

  @override
  State<OrderAbleColumn> createState() => _OrderAbleColumnState();
}

class _OrderAbleColumnState extends State<OrderAbleColumn> {
  final _picker = ImagePicker();
  late EditProfileNotifier edit;

  @override
  void initState() {
    super.initState();

    edit = context.read<EditProfileNotifier>();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final String item = widget.profilePics.removeAt(oldIndex);
      widget.profilePics.insert(newIndex, item);

      edit.updateProfile(profilePics: widget.profilePics);
    });
  }

  void _deleteImage(int index) {
    setState(() {
      widget.profilePics.removeAt(index);

      edit.updateProfile(profilePics: widget.profilePics);
    });
  }

  Future<bool> _handlePermissions({int? index}) async {
    return await FileService.handlePermissions(
      context: context,
      showDialog: showSettingsDialog,
      showSnackbar: (message) => showSnackbar(message, context),
      index: index,
      onAddPhoto: _addPhoto,
    );
  }

  Future<bool> _addPhoto({int? index}) async {
    bool result = false;

    try {
      // Request to pick an image from the gallery
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        final croppedImage =
            await FileService.cropImage(File(pickedImage.path));

        if (croppedImage != null) {
          setState(() {
            if (index != null &&
                index >= 0 &&
                index < widget.profilePics.length) {
              // Replace the existing element at the specified index
              widget.profilePics[index] = croppedImage.path;
            } else {
              // Add the new image to the end of the list
              widget.profilePics.add(croppedImage.path);
            }

            result = true;

            edit.updateProfile(profilePics: widget.profilePics);
          });
        }
      }
    } catch (e) {
      // Throw an error if permission is denied
      log('Error picking image: $e');
      rethrow;
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 66,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildDraggableImageView(index: 0, flex: 6),
              addWidth(7),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildDraggableImageView(index: 1),
                    addHeight(7),
                    buildDraggableImageView(index: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
        addHeight(7),
        Expanded(
          flex: 34,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildDraggableImageView(index: 3),
              addWidth(7),
              buildDraggableImageView(index: 4),
              addWidth(7),
              buildDraggableImageView(index: 5),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildDraggableImageView({required int index, int? flex}) {
    return Expanded(
      flex: flex ?? 1,
      child: Builder(
        builder: (_) {
          if (index >= widget.profilePics.length) {
            // Return a fallback widget or an empty container
            return EmptyView(onActionTap: _handlePermissions);
          }

          return LongPressDraggable<int>(
            data: index,
            feedback: Opacity(
              opacity: 0.8,
              child: ImageView(
                index: index,
                isDragged: true,
                profilePics: widget.profilePics,
              ),
            ),
            childWhenDragging: Container(decoration: editMediaDecoration),
            onDragStarted: () => Vibrate.feedback(FeedbackType.success),
            child: DragTarget<int>(
              builder: (ctx, candidateData, rejectedData) {
                bool isDraggingOver = candidateData.isNotEmpty;

                return Stack(
                  children: [
                    ImageView(
                      index: index,
                      profilePics: widget.profilePics,
                      onEditTap: () => showCustomModalBottomSheet(
                        context,
                        onDelete: () => _deleteImage(index),
                        onReUpload: () => _handlePermissions(index: index),
                      ),
                    ),
                    if (isDraggingOver)
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      ),
                  ],
                );
              },
              onWillAcceptWithDetails: (data) => data.data != index,
              onAcceptWithDetails: (targetDetails) =>
                  _onReorder(targetDetails.data, index),
            ),
          );
        },
      ),
    );
  }
}

void showCustomModalBottomSheet(
  BuildContext context, {
  required VoidCallback onDelete,
  required Future<bool> Function() onReUpload,
}) {
  showModalBottomSheet<void>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => EditSheet(
      onDelete: onDelete,
      onReUpload: onReUpload,
    ),
  );
}
