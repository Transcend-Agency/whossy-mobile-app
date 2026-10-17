import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/component_style.dart';
import '../../styles/text_style.dart';

class MessageTextField extends StatelessWidget {
  const MessageTextField({
    super.key,
    required this.node,
    required this.controller,
    this.onPrefixIconTap,
    this.isReplying = false,
    this.enabled = true,
    this.hintText = 'Say something nice',
    this.onFieldSubmitted,
  });

  final FocusNode node;
  final Color textColor = Colors.black;
  final void Function(String)? onFieldSubmitted;
  final TextEditingController controller;
  final VoidCallback? onPrefixIconTap;
  final bool isReplying;
  final String hintText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final Color effectiveTextColor =
        enabled ? textColor : textColor.withOpacity(0.7);

    return TextFormField(
      style: TextStyles.hintThemeText.copyWith(
        color: effectiveTextColor,
      ),
      maxLines: null,
      cursorColor: Colors.black,
      focusNode: node,
      textInputAction: TextInputAction.newline,
      controller: controller,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(8.r).copyWith(left: 12.r),
        enabledBorder: customBorder(isReplying: isReplying),
        focusedBorder: customBorder(isReplying: isReplying),
        fillColor: AppColors.listTileColor,
        hintText: hintText,
      ),
    );
  }
}
