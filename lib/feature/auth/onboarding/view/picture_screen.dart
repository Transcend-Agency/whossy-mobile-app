import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/data/state/onboarding_notifier.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';

class PictureScreen extends StatefulWidget {
  final int pageIndex;

  const PictureScreen({super.key, required this.pageIndex});

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

// Todo: Configure App check
class _PictureScreenState extends State<PictureScreen>
    with AutomaticKeepAliveClientMixin<PictureScreen> {
  late OnboardingNotifier onboarding;
  final double rotationAngle = 5 * math.pi / 180;

  final _picker = ImagePicker();
  List<File> _images = [];

  /// Select image from gallery
  Future<void> _pickImages() async {
    if (_images.length < 6) {
      final pickedImages = await _picker.pickMultiImage(limit: 6);

      for (var file in pickedImages) {
        final croppedImage = await _cropImage(File(file.path));
        if (croppedImage != null) {
          setState(() {
            _images.add(croppedImage);

            // Ensure the list does not exceed 6 images
            if (_images.length > 6) {
              _images = _images.sublist(0, 6);
            }
          });

          final valid = _images.length >= 3;

          if (onboarding.isSelected(widget.pageIndex) != valid) {
            onboarding.select(widget.pageIndex, value: valid);
          }
        }
      }
      // Call updateUserProfile after all images are processed
      onboarding.updateUserProfile(picFiles: _images);
    } else {
      log('Delete pictures to add more');
    }
  }

  Future<File?> _cropImage(File image) async {
    final croppedImage = await ImageCropper().cropImage(
      sourcePath: image.path,
      aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
    );

    if (croppedImage == null) return null;

    return File(croppedImage.path);
  }

  @override
  void initState() {
    onboarding = Provider.of<OnboardingNotifier>(context, listen: false);
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
          subtitle: "Add at least 2 recent photos of yourself 🤗",
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
        Center(
          child: SizedBox(
            height: 340.h,
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
                      Positioned(
                        top: -15,
                        left: 0,
                        child: GestureDetector(
                          onTap: _pickImages,
                          child: SvgPicture.asset(AppAssets.cam1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        addHeight(96),
        SizedBox(
          height: 76.r,
          child: ListView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: List.generate(5, (_) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80.r,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      decoration: BoxDecoration(
                        color: AppColors.listTileColor,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: _images.length - 1 > _
                          ? Image.file(_images[_ + 1], fit: BoxFit.cover)
                          : null,
                    ),
                    Positioned(
                      top: -4,
                      left: -2,
                      child: SvgPicture.asset(AppAssets.cam2, width: 25.r),
                    ),
                  ],
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
