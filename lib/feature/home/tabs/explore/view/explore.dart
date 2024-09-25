import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';
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
            const HeaderBar(
              icon: CupertinoIcons.bell_fill,
              icon2: AppAssets.explore,
            ),
            addHeight(16),
            const ExploreFilters(),
          ],
        ),
      ),
    );
  }
}
