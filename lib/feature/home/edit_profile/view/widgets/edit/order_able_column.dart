import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
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
    required this.edit,
  });

  final List<String> profilePics;
  final EditProfileNotifier edit;

  @override
  State<OrderAbleColumn> createState() => _OrderAbleColumnState();
}

class _OrderAbleColumnState extends State<OrderAbleColumn> {
  late StreamSubscription subscription;

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

  Future<void> _addPhoto() async {
    final pickedImage = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final croppedImage = await FileService.cropImage(File(pickedImage.path));

      if (croppedImage != null) {
        setState(() {
          widget.profilePics.add(pickedImage.path);

          widget.edit.updateProfile(profilePics: widget.profilePics);
        });
      }
    }
  }

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
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
      child: Selector<ConnectivityNotifier, bool>(
        selector: (_, connect) => connect.isConnected,
        builder: (_, connected, __) {
          if (index >= widget.profilePics.length) {
            // Return a fallback widget or an empty container
            return EmptyView(onActionTap: _addPhoto);
          }

          // if (!connected) {
          //   return EmptyView(
          //     noConnection: true,
          //     imagePath: widget.profilePics[index],
          //     onActionTap: () => showCustomModalBottomSheet(
          //       context,
          //       () => _deleteImage(index),
          //     ),
          //   );
          // }

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
            onDragStarted: () => HapticFeedback.lightImpact(),
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
                        () => _deleteImage(index),
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
      ),
    );
  }
}

void showCustomModalBottomSheet(
  BuildContext context,
  VoidCallback onDelete,
) {
  showModalBottomSheet<void>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => EditSheet(onDelete: onDelete),
  );
}
