import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../model/guide_detail.dart';

class ModalContent extends StatelessWidget {
  final GuideDetail data;

  const ModalContent({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        addHeight(100),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            data.header,
            style: TextStyles.title.copyWith(fontSize: 25.sp),
          ),
        ),
        const Divider(
          color: AppColors.outlinedColor,
          height: 0,
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: data.items.asMap().entries.map((entry) {
            int index = entry.key; // Get the index
            var item = entry.value; // Get the item

            return Padding(
              padding: EdgeInsets.only(top: 18.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text(
                      '${index + 1}. ${item.title}',
                      style: TextStyles.boldPrefText.copyWith(
                        fontSize: AppUtils.scale(13.sp) ?? 15.sp,
                      ),
                    ),
                  ),
                  addHeight(6),
                  Text(
                    item.subTitle,
                    style: TextStyles.boldPrefText.copyWith(
                      color: AppColors.hintTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}
