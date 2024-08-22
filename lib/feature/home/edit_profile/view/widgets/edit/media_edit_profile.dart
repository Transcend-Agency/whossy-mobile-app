import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../constants/index.dart';

class MediaEditProfile extends StatelessWidget {
  const MediaEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Media(Photo and videos)',
                      style: TextStyles.prefText,
                    ),
                    addWidth(10),
                    AppChip(
                      data: '+40%',
                      isSelected: false,
                      outlined: false,
                      isBold: true,
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: AppColors.outlinedColor,
                height: 0,
              ),
            ],
          ),
        )
      ],
    );
  }
}
