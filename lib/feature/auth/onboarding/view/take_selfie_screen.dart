import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/components.dart';
import '../../../../common/utils/services/services.dart';
import '../../../../common/utils/utils.dart';
import '../../../../constants/index.dart';
import '../../../../provider/provider.dart';
import 'edit_sheet.dart';

class TakeSelfieScreen extends StatefulWidget {
  final int pageIndex;

  const TakeSelfieScreen({super.key, required this.pageIndex});

  @override
  State<TakeSelfieScreen> createState() => _TakeSelfieScreenState();
}

class _TakeSelfieScreenState extends State<TakeSelfieScreen>
    with AutomaticKeepAliveClientMixin<TakeSelfieScreen> {
  late OnboardingNotifier onboarding;

  final _picker = ImagePicker();
  File? _image;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onboarding = context.read<OnboardingNotifier>();
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
        setState(() => _image = File(pickedImage.path));

        onboarding.select(widget.pageIndex);

        // Call updateUserProfile with the single image
        onboarding.updateUserProfile(verPicFile: _image);

        result = true;
      }
    } catch (e) {
      // Handle error
      log('Error picking image: $e');
      rethrow;
    }

    return result; // Return true if image was picked and set successfully
  }

  Future<void> _deletePhoto() async {
    try {
      // Reset the _image variable, effectively removing the photo
      setState(() => _image = null);

      onboarding.updateUserProfile(verPicFile: null);
    } catch (e) {
      log('Error deleting photo: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OnboardingHeaderText(
          title: _image != null
              ? AppStrings.onboardingSelfieRetakeTitle
              : AppStrings.onboardingSelfieTitle,
          subtitle: _image != null
              ? AppStrings.onboardingSelfieRetakeSubtitle
              : AppStrings.onboardingSelfieSubtitle,
          skip: true,
        ),
        addHeight(42),
        Center(
          child: GestureDetector(
            onTap: () {
              // If no image is selected, handle permissions
              if (_image == null) {
                _handlePermissions(); // Trigger photo capturing
              } else {
                // Show the bottom modal to either retake or proceed
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
                      // Show image if one is selected
                      if (_image != null)
                        Image.file(
                          _image!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      // SVG camera icon over the image
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

  @override
  bool get wantKeepAlive => true;
}
