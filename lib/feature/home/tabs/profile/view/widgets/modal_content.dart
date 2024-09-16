import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../model/guide_detail.dart';

class ModalContent extends StatelessWidget {
  final GuideDetail data;
  final int index;

  const ModalContent({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
          ),
          child: Image.asset(
            'assets/images/safety${index + 1}.png',
            height: 175.h,
            fit: BoxFit.cover,
          ),
        ),
        addHeight(12),
        Padding(
          padding: pagePadding,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              data.header,
              style: TextStyles.title.copyWith(fontSize: 24.sp),
            ),
          ),
        ),
        Padding(
          padding: pagePadding,
          child: const Divider(
            color: AppColors.outlinedColor,
            height: 0,
          ),
        ),
        Padding(
          padding: pagePadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...data.items.asMap().entries.map((entry) {
                int index = entry.key; // Get the index
                var item = entry.value; // Get the item

                return Padding(
                  padding: EdgeInsets.only(top: 18.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${data.header != 'FAQs' ? '${index + 1}.' : ''} ${item.title}',
                        style: TextStyles.boldPrefText.copyWith(),
                      ),
                      addHeight(6),
                      Text(
                        item.subTitle,
                        style: TextStyles.boldPrefText.copyWith(
                          color: AppColors.hintTextColor,
                          fontWeight: FontWeight.w400,
                          fontSize: AppUtils.scale(11.sp) ?? 13.sp,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              // Adding the spacer as the last item in the column
            ],
          ),
        )
      ],
    );
  }
}
