import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/styles/component_style.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/feature/home/tabs/explore/view/widgets/explore_filters_component.dart';
import 'package:whossy_app/feature/home/tabs/explore/view/widgets/grid/explore_grid.dart';
import 'package:whossy_app/feature/home/tabs/explore/view/widgets/search/explore_search_bar.dart';
import 'package:whossy_app/feature/home/tabs/explore/view/widgets/search/search_results_grid.dart';

import '../../../../../../common/utils/utils.dart';
import '../../../../../common/components/components.dart';
import '../../../../../constants/index.dart';
import '../../../notifications/view/widgets/notification_bell.dart';
import '../data/state/user_search_notifier.dart';

class Explore extends StatelessWidget {
  const Explore({super.key});

  @override
  Widget build(BuildContext context) {
    final searching = context.select<UserSearchNotifier, bool>((s) => s.isSearching);

    return SizedBox(
      width: 375.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: pagePadding,
            child: HeaderBar(
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
          ),
          addHeight(4),
          Padding(
            padding: pagePadding,
            child: const ExploreSearchBar(),
          ),
          addHeight(8),
          // While a name is typed, search results replace the filters and
          // the grid; clearing the box brings them back as they were.
          if (!searching) const ExploreFiltersComponent(),
          Expanded(
            child: Padding(
              padding: pagePadding,
              child: searching ? const SearchResultsGrid() : const ExploreGrid(),
            ),
          ),
        ],
      ),
    );
  }
}
