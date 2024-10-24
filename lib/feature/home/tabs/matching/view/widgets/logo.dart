import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          AppAssets.logoColored,
          width: 30.r,
        ),
        addWidth(6),
        Column(
          children: [
            addHeight(4),
            SvgPicture.asset(
              AppAssets.whossyColored,
              width: 100,
            ),
          ],
        ),
      ],
    );
  }
}
