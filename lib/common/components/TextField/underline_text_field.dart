import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/app_utils.dart';

class UnderlineTextField extends StatelessWidget {
  const UnderlineTextField({
    super.key,
    required this.focusNode,
    required this.textController,
    this.onFieldSubmitted,
    required this.maxLength,
  });

  final FocusNode focusNode;
  final int maxLength;
  final TextEditingController textController;
  final void Function(String)? onFieldSubmitted;

  final Color textColor = AppColors.black;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyles.hintThemeText.copyWith(
        color: textColor,
        fontSize: AppUtils.scale(10.5.sp),
      ),
      cursorColor: textColor,
      focusNode: focusNode,
      controller: textController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: onFieldSubmitted,
      maxLength: maxLength,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        counterText: '',
        focusedBorder: underlinedInputBorder,
        enabledBorder: underlinedInputBorder.copyWith(
            borderSide:
                const BorderSide(width: 0.5, color: AppColors.outlinedColor)),
        contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
      ),
    );
  }
}
