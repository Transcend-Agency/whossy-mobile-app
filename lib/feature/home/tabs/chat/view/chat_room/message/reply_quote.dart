import 'package:flutter/material.dart';

import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../constants/colors.dart';

/// The quoted message: a coloured bar, who wrote it, and two lines of it.
/// Used inside a reply bubble and in the "Replying to" bar above the input.
class ReplyQuote extends StatelessWidget {
  const ReplyQuote({
    super.key,
    required this.name,
    required this.preview,
    required this.isOwn,
    required this.fontSize,
    this.background,
    this.trailing,
  });

  /// "You" or the other person's name.
  final String name;
  final String preview;

  /// Whether the quoted message is yours; it sets the bar's colour.
  final bool isOwn;
  final double fontSize;
  final Color? background;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final accent = isOwn ? AppColors.saveColor : AppColors.primaryColor;
    final textSize = fontSize - 2;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: background ?? Colors.black.withValues(alpha: 0.05),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accent),
              Flexible(
                fit: FlexFit.tight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.messageText(textSize).copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.messageText(textSize).copyWith(
                          color: AppColors.messageMetaColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
