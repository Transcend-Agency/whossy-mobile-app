import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../common/styles/component_style.dart';
import '../../../../../../../../common/styles/text_style.dart';
import '../../../../../../../../common/utils/router/router.gr.dart';
import '../../../../../../../../common/utils/utils.dart';
import '../../../../../../../../constants/index.dart';
import '../../../../../../../../provider/provider.dart';
import '../../../../model/explore_filters.dart';

/// Shown when the selected Explore filter finds nobody. Offers the way out
/// that fits the filter: re-open Advanced search, or go back to Discover.
class EmptyDataGrid extends StatelessWidget {
  const EmptyDataGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final explore = context.read<ExploreNotifier>();
    final isAdvanced = explore.getFilter(Filters.advancedSearch) != null;
    final isDiscover = explore.getFilter(Filters.discover) != null;

    final String? actionLabel = isAdvanced
        ? 'Adjust search'
        : isDiscover
            ? null
            : 'Show ${Filters.discover.label}';

    return Center(
      key: const ValueKey('empty'),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(AppAssets.noLikes, height: 100.r),
            addHeight(12),
            Text(
              'No profiles match right now',
              style: TextStyles.boldPrefText,
              textAlign: TextAlign.center,
            ),
            addHeight(6),
            Text(
              isAdvanced
                  ? 'Try widening your age range or relationship preference.'
                  : 'Try a different filter, or check back soon as new people join every day.',
              style: TextStyles.prefText.copyWith(
                color: AppColors.hintTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              addHeight(16),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.listTileColor,
                  shape: circularBorder,
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 10.h,
                  ),
                ),
                onPressed: () {
                  if (isAdvanced) {
                    Nav.push(context, const AdvancedSearchRoute());
                  } else {
                    explore.clearFilters();
                    explore.addFilter(Filters.discover, '');
                  }
                },
                child: Text(
                  actionLabel,
                  style: TextStyles.boldPrefText.copyWith(
                    color: AppColors.buttonColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
