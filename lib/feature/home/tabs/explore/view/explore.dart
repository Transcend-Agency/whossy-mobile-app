import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/explore/view/widgets/filters.dart';

import '../../../../../../common/utils/index.dart';
import '../../../../../common/components/index.dart';
import '../../../../../constants/index.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375.w,
      child: Padding(
        padding: pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            addHeight(12),
            HeaderBar(
              icon: CupertinoIcons.bell_fill,
              icon2: AppAssets.explore,
              onIcon2Tap: () => Nav.push(context, const AdvancedSearchRoute()),
            ),
            addHeight(16),
            const ExploreFilters(),
          ],
        ),
      ),
    );
  }
}
