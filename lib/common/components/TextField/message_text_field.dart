import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../constants/index.dart';
import '../../styles/component_style.dart';
import '../../../feature/home/tabs/chat/data/state/chat_text_size_notifier.dart';
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
        enabled ? textColor : textColor.withValues(alpha: 0.7);

    // Same size and weight as the message bubbles, so what you type looks
    // like what you send.
    final style = TextStyles.messageText(
      context.select<ChatTextSizeNotifier, double>((n) => n.fontSize),
    );

    return TextFormField(
      style: style.copyWith(color: effectiveTextColor),
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
        hintStyle: style.copyWith(
          color: AppColors.hintTextColor,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
