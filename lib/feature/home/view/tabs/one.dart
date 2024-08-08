import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';

class One extends StatelessWidget {
  const One({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375.w,
      child: Column(
        children: [
          addHeight(36),
          Text(
            'One',
            style: TextStyles.title.copyWith(fontSize: 24.sp),
          ),
        ],
      ),
    );
  }
}
