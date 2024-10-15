import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/index.dart';
import 'package:whossy_app/provider/providers.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../constants/index.dart';
import 'order_able_column.dart';

class MediaEditProfile extends StatelessWidget {
  const MediaEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // Fixed total height
    final double totalHeight = ScreenUtil().screenHeight * 0.4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: const BoxDecoration(color: AppColors.inputBackGround),
          padding: EdgeInsets.symmetric(horizontal: 14.r, vertical: 12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Hold down and drag to rearrange',
                style: TextStyles.prefText,
                textAlign: TextAlign.left,
              ),
              addHeight(12),
              Selector<EditProfileNotifier, List<String>>(
                selector: (_, edit) => edit.coreProfile?.profilePics ?? [],
                builder: (_, profilePics, __) {
                  return SizedBox(
                    height: totalHeight,
                    child: OrderAbleColumn(profilePics: profilePics),
                  );
                },
              ),
              addHeight(2),
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
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.r),
                    ),
                  ],
                ),
              ),
              const AppDivider(),
            ],
          ),
        )
      ],
    );
  }
}
