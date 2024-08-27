import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';

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
    this.validation,
    this.validationMode,
    this.contentPadding,
  });

  final FocusNode focusNode;
  final int? maxLength;
  final String? hintText;
  final TextEditingController textController;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validation;
  final TextInputAction action;
  final bool filled;
  final TextAlign align;
  final TextInputType keyType;
  final List<TextInputFormatter>? format;
  final AutovalidateMode? validationMode;
  final EdgeInsets? contentPadding;

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
      errorBorder: underlinedInputBorder.copyWith(
        borderSide:
            const BorderSide(width: 0.5, color: AppColors.sbErrorBorderColor),
      ),
      focusedErrorBorder: underlinedInputBorder.copyWith(
        borderSide: const BorderSide(color: AppColors.sbErrorBorderColor),
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
      validator: validation,
      keyboardType: keyType,
      autovalidateMode: validationMode,
      inputFormatters: keyType == TextInputType.number ? format : null,
      decoration: _inputDecoration.copyWith(contentPadding: contentPadding),
    );
  }
}
