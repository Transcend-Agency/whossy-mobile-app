import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/app_utils.dart';

class CustomTile extends StatelessWidget {
  const CustomTile({
    super.key,
    required this.leading,
    required this.subTitle,
    required this.title,
    this.useSvg = false,
    this.svgPath,
  }) : assert(!useSvg || svgPath != null,
            'If useSvg is true then svgPath must be provided');

  final String leading;
  final String subTitle;
  final String title;
  final bool useSvg;
  final String? svgPath;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      visualDensity: VisualDensity.standard,
      leading: useSvg
          ? SvgPicture.asset(svgPath!, height: 34.r)
          : Text(
              leading,
              style: TextStyles.iconText.copyWith(
                fontSize: AppUtils.scale(20.sp),
              ),
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
