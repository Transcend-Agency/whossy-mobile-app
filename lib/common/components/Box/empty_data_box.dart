import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../styles/text_style.dart';

class EmptyDataBox extends StatelessWidget {
  const EmptyDataBox({
    super.key,
    required this.image,
    required this.text,
    this.imageSize = 110,
    this.spacing,
  });

  final String image;
  final String text;
  final double imageSize;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            height: imageSize.r,
          ),
          addHeight(spacing ?? 0),
          Text(
            text,
            style: TextStyles.boldPrefText,
          ),
        ],
      ),
    );
  }
}
