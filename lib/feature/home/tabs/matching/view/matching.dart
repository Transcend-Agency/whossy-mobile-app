import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/matching/view/widgets/match.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';

class Matching extends StatelessWidget {
  const Matching({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding,
      child: SizedBox(
        width: 375.w,
        child: Column(
          children: [
            HeaderBar(
              icon: AppAssets.bell,
              onIconTap: () => Nav.push(context, const NotificationRoute()),
              child: const Logo(),
            ),
            const Expanded(child: Match()),
          ],
        ),
      ),
    );
  }
}
