import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../constants/index.dart';

class Messages extends StatelessWidget {
  const Messages({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.noMessages,
              height: 110.r,
            ),
            Text(
              'No messages yet',
              style: TextStyles.boldPrefText,
            ),
          ],
        ),
      ),
    );
  }
}
