import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/services/file_service.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/providers.dart';
import '../../../../../auth/onboarding/view/edit_sheet.dart';
import 'image_view.dart';

class OrderAbleColumn extends StatefulWidget {
  const OrderAbleColumn({
    super.key,
    required this.profilePics,
    required this.edit,
  });

  final List<String> profilePics;
  final EditProfileNotifier edit;

  @override
  State<OrderAbleColumn> createState() => _OrderAbleColumnState();
}

class _OrderAbleColumnState extends State<OrderAbleColumn> {
  final _picker = ImagePicker();

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final String item = widget.profilePics.removeAt(oldIndex);
      widget.profilePics.insert(newIndex, item);

      widget.edit.updateProfile(profilePics: widget.profilePics);
    });
  }

  void _deleteImage(int index) {
    setState(() {
      widget.profilePics.removeAt(index);

      widget.edit.updateProfile(profilePics: widget.profilePics);
    });
  }

  Future<bool?> showDialog() => showConfirmationDialog(
        yes: 'Open Settings',
        no: 'Cancel',
        context,
        title: 'Permission required',
        content: "Please grant photo access in the app settings.",
      );

  Future<bool> _handlePermissions({int? index}) async {
    bool value = false;

    try {
      // Check if the platform is iOS
      if (Platform.isIOS) {
        var status = await Permission.photos.status;

        if (status.isGranted) {
          value = await _addPhoto(index: index);
        } else if (status.isDenied || status.isPermanentlyDenied) {
          var result = await showDialog();
          if (result == true) openAppSettings();
        }
      } else {
        // For Android, no permission needed
        value = await _addPhoto(index: index);
      }
    } catch (e) {
      showSnackbar(AppStrings.deniedAccess);
    }

    return value;
  }

  Future<bool> _addPhoto({int? index}) async {
    bool result = false;

    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final croppedImage = await FileService.cropImage(File(pickedImage.path));

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

          widget.edit.updateProfile(profilePics: widget.profilePics);
        });
      }
    }

    return result;
  }

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(
        Overlay.of(context),
        displayDuration: const Duration(seconds: 5),
        AppSnackbar(
          text: message,
          label: 'Settings',
          onLabelTapped: openAppSettings,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 66,
          child: Row(
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
              onDragStarted: () => Vibrate.feedback(FeedbackType.selection),
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
                onAcceptWithDetails: (_) => _onReorder(_.data, index),
              ),
            );
          },
        ));
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
