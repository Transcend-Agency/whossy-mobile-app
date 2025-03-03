import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/utils/services/services.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../../../constants/index.dart';
import '../../../../../auth/onboarding/view/edit_sheet.dart';

class TakeSelfie extends StatefulWidget {
  const TakeSelfie({
    super.key,
    this.photoUrl,
    required this.imagePickedNotifier,
    required this.onImagePicked,
  });

  final String? photoUrl;
  final ValueNotifier<bool> imagePickedNotifier;
  final ValueChanged<File?> onImagePicked;

  @override
  State<TakeSelfie> createState() => _TakeSelfieState();
}

class _TakeSelfieState extends State<TakeSelfie> {
  final _picker = ImagePicker();
  File? _image;
  String? currentImage;

  @override
  void initState() {
    super.initState();
    currentImage = widget.photoUrl;
    _updateImageStatus();
  }

  void _updateImageStatus() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.imagePickedNotifier.value =
          (_image != null || currentImage != null) && _image != null;
      // Notify parent when the image is updated
      widget.onImagePicked(_image); // Trigger the callback
    });
  }

  Future<bool> _handlePermissions({int? index}) async {
    return await FileService.handlePermissions(
      context: context,
      showDialog: showSettingsDialog,
      showSnackbar: (message) => showSnackbar(
        message,
        context,
        label: 'Settings',
        durationInSec: 5,
      ),
      index: index,
      onAddPhoto: _addPhoto,
    );
  }

  Future<bool> _addPhoto({int? index}) async {
    bool result = false;
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);
        });
        _updateImageStatus();
        result = true;
      }
    } catch (e) {
      log('Error picking image: $e');
      rethrow;
    }
    return result;
  }

  Future<void> _deletePhoto() async {
    setState(() {
      _image = null;
      currentImage = null;
    });
    _updateImageStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        addHeight(20),
        OnboardingHeaderText(
          title: _image != null || currentImage != null
              ? AppStrings.onboardingSelfieRetakeTitle
              : AppStrings.onboardingSelfieTitle,
          subtitle: _image != null || currentImage != null
              ? AppStrings.onboardingSelfieRetakeSubtitle
              : AppStrings.onboardingSelfieSubtitle,
        ),
        addHeight(42),
        // Your existing UI components
        Center(
          child: GestureDetector(
            onTap: () {
              if (_image == null && currentImage == null) {
                _handlePermissions();
              } else {
                showEditPhotoSheet(
                  context,
                  onDelete: _deletePhoto,
                  onReUpload: _handlePermissions,
                );
              }
            },
            child: SizedBox(
              height: 300.h,
              child: AspectRatio(
                aspectRatio: 0.85,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: AppColors.listTileColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (_image != null)
                        Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        )
                      else if (currentImage != null)
                        if (currentImage!.isUrl)
                          CachedNetworkImage(
                            imageUrl: currentImage!,
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
                            placeholder: (_, __) =>
                                const ShimmerWidget.rectangular(),
                            errorWidget: (context, url, error) {
                              log('Error loading image: ${error.toString()}');
                              return offline(size: 24);
                            },
                          )
                        else
                          Image.file(
                            File(currentImage!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                      SvgPicture.asset(
                        AppAssets.cam2,
                        width: 32.r,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
