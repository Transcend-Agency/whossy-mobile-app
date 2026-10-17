import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/utils/utils.dart';

import '../../styles/text_style.dart';

class EmptyDataBox extends StatelessWidget {
  const EmptyDataBox({
    super.key,
    this.image,
    this.text = '',
    this.imageSize = 120,
    this.spacing,
    this.header,
  }) : assert(image != null || header != null,
            'Either image or header must be provided. Both cannot be null.');

  final String? image;
  final String text;
  final double imageSize;
  final double? spacing;
  final Widget? header;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null) header!,
          if (image != null) Image.asset(image!, height: imageSize.r),
          addHeight(spacing ?? 0),
          if (text.isNotEmpty)
            Text(
              text,
              style: TextStyles.boldPrefText,
            ),
        ],
      ),
    );
  }
}
