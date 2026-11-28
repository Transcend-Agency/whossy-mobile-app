import 'dart:math' as math;

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
    this.expand = false,
  });

  /// "You" or the other person's name.
  final String name;
  final String preview;

  /// Whether the quoted message is yours; it sets the bar's colour.
  final bool isOwn;
  final double fontSize;
  final Color? background;
  final Widget? trailing;

  /// Fill the available width rather than shrinking to the quote's text.
  final bool expand;

  // The bar and the text padding beside it.
  static const _barWidth = 4.0;
  static const _horizontalPadding = 20.0;

  static TextStyle _nameStyle(double fontSize) =>
      TextStyles.messageText(fontSize - 2).copyWith(
        fontWeight: FontWeight.w700,
      );

  static TextStyle _previewStyle(double fontSize) =>
      TextStyles.messageText(fontSize - 2).copyWith(
        color: AppColors.messageMetaColor,
        fontWeight: FontWeight.w400,
      );

  /// How wide the quote is when nothing squeezes it: its name or its text on
  /// one line, whichever is longer, plus the bar and padding. The reply
  /// bubble uses this to size itself, because the message text below can't
  /// report its natural width to Flutter's intrinsic sizing.
  static double naturalWidth({
    required String name,
    required String preview,
    required double fontSize,
    required TextScaler textScaler,
  }) {
    double measure(String text, TextStyle style) {
      final painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
        maxLines: 1,
      )..layout();
      final width = painter.width;
      painter.dispose();
      return width;
    }

    return _barWidth +
        _horizontalPadding +
        math.max(
          measure(name, _nameStyle(fontSize)),
          measure(preview, _previewStyle(fontSize)),
        );
  }

  @override
  Widget build(BuildContext context) {
    final accent = isOwn ? AppColors.saveColor : AppColors.primaryColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        color: background ?? Colors.black.withValues(alpha: 0.05),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: _barWidth, color: accent),
              Flexible(
                fit: expand ? FlexFit.tight : FlexFit.loose,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    _horizontalPadding / 2,
                    6,
                    _horizontalPadding / 2,
                    6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _nameStyle(fontSize).copyWith(color: accent),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        preview,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: _previewStyle(fontSize),
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
