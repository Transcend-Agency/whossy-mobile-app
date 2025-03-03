import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../../constants/index.dart';

class LikeIcon extends StatelessWidget {
  const LikeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, right: 10),
        child: Image.asset(
          AppAssets.like,
          width: 22.r,
        ),
      ),
    );
  }
}
