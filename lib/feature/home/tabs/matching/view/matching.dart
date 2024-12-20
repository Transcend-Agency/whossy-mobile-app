import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/matching/view/widgets/match.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../common/utils/index.dart';
import '../../../notifications/view/widgets/notification_bell.dart';

class Matching extends StatelessWidget {
  const Matching({super.key});

  static String name = 'Matching';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: pagePadding,
      child: SizedBox(
        width: 375.w,
        child: Column(
          children: [
            HeaderBar(
              customWidget: NotificationBell(
                onTap: () => Nav.push(context, const NotificationRoute()),
                rightSpacing: 2,
              ),
              child: const Logo(),
            ),
            const Expanded(child: Match()),
          ],
        ),
      ),
    );
  }
}
