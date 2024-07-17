import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants/colors.dart';
import '../../styles/component_style.dart';
import '../../styles/text_style.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.focusNode,
    required this.textController,
    required this.hintText,
    this.validation,
    this.suffixIcon,
    this.obscureText = false,
    this.action = TextInputAction.next,
    this.onFieldSubmitted,
    this.focusedBorderColor,
    this.maxLength,
    this.lengthLimit,
    this.isPhone = false,
    this.isUsername = false,
    this.prefixIcon,
  });

  final FocusNode focusNode;
  final TextEditingController textController;
  final void Function(String)? onFieldSubmitted;
  final String hintText;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validation;
  final TextInputAction action;
  final bool obscureText;
  final Color? focusedBorderColor;
  final Color textColor = AppColors.black;
  final int? maxLength;
  final int? lengthLimit;
  final bool isPhone;
  final bool isUsername;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: isPhone ? TextInputType.phone : null,
      style: TextStyles.hintThemeText.copyWith(color: textColor),
      maxLength: maxLength,
      cursorColor: textColor,
      focusNode: focusNode,
      controller: textController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: obscureText,
      textInputAction: action,
      validator: validation,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: [
        isPhone
            ? _PhoneNumberFormatter()
            : FilteringTextInputFormatter(RegExp('.'), allow: true),
        LengthLimitingTextInputFormatter(maxLength ?? lengthLimit),
        if (isUsername) LowercaseTextFormatter()
      ],
      decoration: InputDecoration(
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(
            color: focusedBorderColor ?? AppColors.selectedFieldColor,
            width: focusedBorderColor == null ? 1 : 0.5,
          ),
        ),
        isDense: true,
        fillColor: AppColors.inputBackGround.withOpacity(0.9),
        hintText: hintText,
        contentPadding: const EdgeInsets.all(18),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    final buffer = StringBuffer();
    int count = 0;

    for (int i = 0; i < text.length; i++) {
      if (text[i].contains(RegExp(r'[0-9]'))) {
        if (count == 2 || count == 5) {
          buffer.write(' ');
        }
        buffer.write(text[i]);
        count++;
      }
    }

    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class LowercaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    );
  }
}
