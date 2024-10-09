import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../../../../../../common/components/index.dart';
import '../../../../../../../common/styles/component_style.dart';
import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../constants/index.dart';

class AddPhotoSheet extends StatelessWidget {
  const AddPhotoSheet(
      {super.key, required this.onTakePhoto, required this.onFromGallery});

  final VoidCallback onTakePhoto;
  final VoidCallback onFromGallery;

  @override
  Widget build(BuildContext context) {
    return AppSheetScaffold(
      title: 'Actions',
      topPadding: 16,
      child: Padding(
        padding: pagePadding,
        child: Wrap(
          runSpacing: 8,
          spacing: 16,
          children: [
            ActionButton(
              onTap: onTakePhoto,
              text: 'Take Photo',
              iconPath: AppAssets.photo,
            ),
            ActionButton(
              onTap: onFromGallery,
              text: 'Add from gallery',
              iconPath: AppAssets.gallery,
            ),
          ],
        ),
      ),
    );
  }
}

Future<Picture?> showAddPhotoSheet(BuildContext context) {
  return showModalBottomSheet<Picture?>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => AddPhotoSheet(
      onTakePhoto: () => Navigator.pop(context, Picture.photo),
      onFromGallery: () => Navigator.pop(context, Picture.gallery),
    ),
  );
}

class ActionButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String iconPath;

  const ActionButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.listTileColor,
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyles.chatText.copyWith(
                color: AppColors.hintTextColor,
              ),
            ),
            addWidth(6),
            SvgPicture.asset(iconPath),
          ],
        ),
      ),
    );
  }
}
