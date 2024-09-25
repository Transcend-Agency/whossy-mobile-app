import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/text_style.dart';

class EmptyDataBox extends StatelessWidget {
  const EmptyDataBox({super.key, required this.image, required this.text});

  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              image,
              height: 110.r,
            ),
            Text(
              text,
              style: TextStyles.boldPrefText,
            ),
          ],
        ),
      ),
    );
  }
}
