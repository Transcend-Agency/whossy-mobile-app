import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/feature/home/tabs/matching/view/widgets/match.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../constants/index.dart';
import 'widgets/logo.dart';

class Matching extends StatelessWidget {
  const Matching({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding,
      child: SizedBox(
        width: 375.w,
        child: const Column(
          children: [
            HeaderBar(
              icon: AppAssets.bell,
              child: Logo(),
            ),
            Expanded(child: Match()),
          ],
        ),
      ),
    );
  }
}
