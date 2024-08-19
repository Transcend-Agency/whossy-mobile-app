import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';

class Four extends StatelessWidget {
  const Four({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375.w,
      child: Column(
        children: [
          addHeight(36),
          Text(
            'Four',
            style: TextStyles.title.copyWith(fontSize: 24.sp),
          ),
        ],
      ),
    );
  }
}
