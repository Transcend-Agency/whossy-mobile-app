import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/explore/view/widgets/explore_filters_component.dart';
import 'package:whossy_app/feature/home/tabs/explore/view/widgets/grid/explore_grid.dart';

import '../../../../../../common/utils/utils.dart';
import '../../../../../common/components/components.dart';
import '../../../../../constants/index.dart';
import '../../../notifications/view/widgets/notification_bell.dart';

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
            HeaderBar(
              customWidget: NotificationBell(
                key: GlobalKeys.notificationKey,
                onTap: () => Nav.push(context, const NotificationRoute()),
                rightSpacing: 0,
              ),
              icon2: AppAssets.explore,
              onIcon2Tap: () => Nav.push(context, const AdvancedSearchRoute()),
              icon2Key: GlobalKeys.advancedSearchKey,
              child: const Logo(),
            ),
            addHeight(4),
            const ExploreFiltersComponent(),
            const Expanded(child: ExploreGrid()),
          ],
        ),
      ),
    );
  }
}
