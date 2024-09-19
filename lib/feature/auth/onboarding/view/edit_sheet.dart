import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/component_style.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';

class EditSheet extends StatelessWidget {
  final VoidCallback onDelete;
  final Future<bool> Function() onReUpload;

  const EditSheet({
    super.key,
    required this.onDelete,
    required this.onReUpload,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Edit photo',
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SizedBox.square(
                      dimension: 30.r,
                      child: cancelIcon(),
                    ),
                  )
                ],
              ),
            ),
            const Divider(
              color: AppColors.outlinedColor,
              height: 0,
            ),
            addHeight(16),
            Padding(
              padding: pagePadding,
              child: OutlinedAppButton(
                onPress: () async {
                  onReUpload().then((success) {
                    if (success) Navigator.pop(context);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: SvgPicture.asset(AppAssets.upload),
                    ),
                    addWidth(12),
                    Text(
                      "Re-upload",
                      style: TextStyles.buttonText.copyWith(
                        color: AppColors.hintTextColor,
                        fontSize: AppUtils.scale(17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 14.w),
              child: OutlinedAppButton(
                onPress: () {
                  onDelete();
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: 1.1,
                      child: SvgPicture.asset(AppAssets.bin),
                    ),
                    addWidth(10),
                    Text(
                      "Delete Photo",
                      style: TextStyles.buttonText.copyWith(
                        color: AppColors.hintTextColor,
                        fontSize: AppUtils.scale(17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            addHeight(6),
          ],
        ),
      ),
    );
  }
}
