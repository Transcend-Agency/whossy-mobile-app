import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/app_utils.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    required this.leading,
    required this.subTitle,
    required this.title,
  });

  final String leading;
  final String subTitle;
  final String title;

  @override
  Widget build(BuildContext context) {
    //
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      visualDensity: VisualDensity.standard,
      leading: SizedBox.square(
        dimension: 38.r,
        child: Image.asset(leading),
      ),
      subtitle: Text(
        subTitle,
        style: TextStyles.hintText.copyWith(
          fontSize: AppUtils.scale(10.sp),
          color: AppColors.black,
        ),
      ),
      title: Text(
        title,
        style: TextStyles.hintText.copyWith(
          fontSize: AppUtils.scale(12.sp),
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
