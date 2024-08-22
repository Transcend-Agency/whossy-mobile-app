import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../../model/info_item.dart';

class PreviewInfoColumn extends StatelessWidget {
  final List<InfoItem> items;

  const PreviewInfoColumn({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          Text(
            items[i].label,
            style: TextStyles.prefText.copyWith(
              color: AppColors.hintTextColor,
              fontSize: AppUtils.scale(10.5.sp) ?? 12.sp,
            ),
          ),
          Text(
            items[i].value,
            style: TextStyles.prefText,
          ),
          if (i < items.length - 1)
            Padding(
              padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
              child: const Divider(
                color: AppColors.outlinedColor,
                height: 0,
              ),
            ),
        ],
      ],
    );
  }
}
