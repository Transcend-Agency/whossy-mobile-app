import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/utils/services/file_service.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/component_style.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import '../data/state/onboarding_notifier.dart';
import 'edit_sheet.dart';

class PictureScreen extends StatefulWidget {
  final int pageIndex;

  const PictureScreen({super.key, required this.pageIndex});

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen>
    with AutomaticKeepAliveClientMixin<PictureScreen> {
  late OnboardingNotifier onboarding;
  final double rotationAngle = 5 * math.pi / 180;

  final _picker = ImagePicker();
  List<File> _images = [];

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
      // Call _addPhoto first
      value = await _addPhoto(index: index);
    } catch (e) {
      // If an error occurs, check the permission status
      if (Platform.isIOS) {
        var status = await Permission.photos.status;

        // Log the permission status
        log('Permission status after error: $status');

        // If permission is not granted, request it
        if (status.isDenied || status.isRestricted) {
          var newStatus = await Permission.photos.request();
          log('New permission status: $newStatus');

          if (newStatus.isGranted) {
            // Retry adding the photo if permission is granted
            value = await _addPhoto(index: index);
          } else if (newStatus.isPermanentlyDenied) {
            // Show dialog to direct the user to settings
            var result = await showDialog();
            if (result == true) {
              openAppSettings();
            }
          }
        }
      } else {
        showSnackbar(AppStrings.deniedAccess);
      }
    }

    return value;
  }

  Future<bool> _addPhoto({int? index}) async {
    bool result = false;
    List<XFile> pickedImages = [];

    try {

       if (index != null) {
        // For re-uploading a single photo
        final pickedImage =
            await _picker.pickImage(source: ImageSource.gallery);
        if (pickedImage != null) pickedImages = [pickedImage];
      } else if (_images.length < 6) {
        // For picking multiple images
        pickedImages = await _picker.pickMultiImage(limit: 6 - _images.length);
      } else {
        log('Delete pictures to add more');
        return result;
      }

      for (var file in pickedImages) {
        final croppedImage = await FileService.cropImage(File(file.path));

        if (croppedImage != null) {
          setState(() {
            if (index != null && index >= 0 && index < _images.length) {
              // Replace the image at the specific index
              _images[index] = croppedImage;
              result = true; // Mark the re-upload as successful
            } else {
              // Add the new image to the list
              _images.add(croppedImage);
            }

            // Ensure the list does not exceed 6 images
            if (_images.length > 6) {
              _images = _images.sublist(0, 6);
            }

            // Update the onboarding state
            final valid = _images.length >= 3;
            if (onboarding.isSelected(widget.pageIndex) != valid) {
              onboarding.select(widget.pageIndex, value: valid);
            }
          });
        }
      }

      // Call updateUserProfile after all images are processed
      onboarding.updateUserProfile(picFiles: _images);

    } catch (e) {
      // Throw an error if permission is denied
      log('Error picking image: $e');
      rethrow;
    }

    return result; // Return true if re-uploading succeeded, otherwise false
  }

  void _moveImageToTop(int index) {
    setState(() {
      AppUtils.moveItemToTop(_images, index);
    });

    // Call updateUserProfile after reordering the images
    onboarding.updateUserProfile(picFiles: _images);
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

  void _deleteImage(int index) {
    setState(() {
      _images.removeAt(index);
      // Ensure to update the onboarding status if necessary
      final valid = _images.length >= 3;
      if (onboarding.isSelected(widget.pageIndex) != valid) {
        onboarding.select(widget.pageIndex, value: valid);
      }
    });

    // Call updateUserProfile after deleting an image
    onboarding.updateUserProfile(picFiles: _images);
  }

  @override
  void initState() {
    onboarding = context.read<OnboardingNotifier>();
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Share a snapshot of you",
          subtitle: "Add at least 3 recent photos of yourself 🤗",
        ),
        addHeight(8),
        Text(
          "Hint: Using your best photo could give a great first "
          "impression and the beginning of something great",
          style: TextStyles.hintText.copyWith(
            fontSize: AppUtils.scale(10.5.sp),
          ),
        ),
        addHeight(42),
        // Todo : Resizing issues in this area
        Center(
          child: SizedBox(
            height: 320.h, // 340
            child: Stack(
              children: [
                ImageCard(
                  heightFactor: 0.8,
                  rotationAngle: rotationAngle * 2,
                  x: 0.8 * 20.w,
                  y: -0.1 * 80.h,
                  color: AppColors.whiteShade200,
                  file: _images.length > 2 ? _images[2] : null,
                ),
                ImageCard(
                  heightFactor: 0.9,
                  rotationAngle: rotationAngle,
                  x: 0.4 * 20.w,
                  y: -0.1 * 40.h,
                  color: AppColors.whiteShade100,
                  file: _images.length > 1 ? _images[1] : null,
                ),
                AspectRatio(
                  aspectRatio: 0.75,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox.expand(
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: AppColors.whiteShade200,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: _images.isNotEmpty
                              ? Image.file(_images[0], fit: BoxFit.cover)
                              : null,
                        ),
                      ),
                      _images.isNotEmpty
                          ? Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  left: -13,
                                  top: -13,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SvgPicture.asset(
                                      AppAssets.dots,
                                      width: 28,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -23,
                                  left: -24,
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: GestureDetector(
                                      onTap: () => showCustomModalBottomSheet(
                                        context,
                                        onDelete: () => _deleteImage(0),
                                        onReUpload: () =>
                                            _handlePermissions(index: 0),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          : Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Positioned(
                                  top: -15,
                                  left: 0,
                                  child: SvgPicture.asset(AppAssets.cam1),
                                ),
                                Positioned(
                                  top: -23,
                                  left: -9,
                                  child: SizedBox(
                                    height: 60,
                                    width: 60,
                                    child: GestureDetector(
                                      onTap: _handlePermissions,
                                    ),
                                  ),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        addHeight(70), // 96
        SizedBox(
          height: 80.r,
          child: ListView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: List.generate(5, (_) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: GestureDetector(
                  onTap: _images.length - 1 > _
                      ? () => _moveImageToTop(_ + 1)
                      : _handlePermissions,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 82.r,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: AppColors.listTileColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: _images.length - 1 > _
                            ? Image.file(_images[_ + 1], fit: BoxFit.cover)
                            : null,
                      ),
                      _images.length - 1 > _
                          ? Positioned(
                              top: -4,
                              left: -4,
                              child: GestureDetector(
                                onTap: () => showCustomModalBottomSheet(
                                  context,
                                  onDelete: () => _deleteImage(_ + 1),
                                  onReUpload: () =>
                                      _handlePermissions(index: _ + 1),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SvgPicture.asset(
                                    AppAssets.dots,
                                    width: 23,
                                  ),
                                ),
                              ),
                            )
                          : Positioned(
                              top: -4,
                              left: -2,
                              child: GestureDetector(
                                onTap: _handlePermissions,
                                child: SvgPicture.asset(
                                  AppAssets.cam2,
                                  width: 27.r,
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

Future<void> showCustomModalBottomSheet(
  BuildContext context, {
  required VoidCallback onDelete,
  required Future<bool> Function() onReUpload,
}) async {
  await showModalBottomSheet<void>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => EditSheet(
      onDelete: onDelete,
      onReUpload: onReUpload,
    ),
  );
}
