import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    this.maxLength,
    this.hintText,
    this.filled = false,
    this.action = TextInputAction.done,
    this.align = TextAlign.start,
    this.keyType = TextInputType.number,
    this.format,
  });

  final FocusNode focusNode;
  final int? maxLength;
  final String? hintText;
  final TextEditingController textController;
  final void Function(String)? onFieldSubmitted;
  final TextInputAction action;
  final bool filled;
  final TextAlign align;
  final TextInputType keyType;
  final List<TextInputFormatter>? format;

  final Color textColor = AppColors.black;

  TextStyle get _textStyle {
    final baseTextStyle = keyType == TextInputType.number
        ? TextStyles.underlineText
        : TextStyles.bioText;

    final fontSize = keyType == TextInputType.number
        ? AppUtils.scale(13.5.sp)
        : AppUtils.scale(10.5.sp);

    return baseTextStyle.copyWith(
      color: textColor,
      fontSize: fontSize,
    );
  }

  InputDecoration get _inputDecoration {
    return InputDecoration(
      filled: filled,
      counterText: '',
      hintText: hintText,
      focusedBorder: underlinedInputBorder,
      enabledBorder: underlinedInputBorder.copyWith(
        borderSide:
            const BorderSide(width: 0.5, color: AppColors.outlinedColor),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 8.h),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: _textStyle,
      cursorColor: textColor,
      focusNode: focusNode,
      textAlign: align,
      controller: textController,
      textInputAction: action,
      onFieldSubmitted: onFieldSubmitted,
      maxLength: maxLength,
      maxLines: null,
      keyboardType: keyType,
      inputFormatters: keyType == TextInputType.number ? format : null,
      decoration: _inputDecoration,
    );
  }
}
