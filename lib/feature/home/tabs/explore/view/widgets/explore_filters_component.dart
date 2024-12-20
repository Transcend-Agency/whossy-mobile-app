import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/feature/home/edit_profile/model/core_profile.dart';

import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/providers.dart';
import '../../model/explore_filters.dart';

class ExploreFiltersComponent extends HookWidget {
  const ExploreFiltersComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final explore = useContext().watch<ExploreNotifier>();
    final profileData = useContext().read<EditProfileNotifier>().coreProfile;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: Filters.values.map((filter) {
          final isSelected = explore.getFilter(filter) != null;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              padding: const EdgeInsets.all(7),
              label: Text(
                filter.label,
                style: TextStyles.prefText.copyWith(
                  color: isSelected ? Colors.white : AppColors.hintTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: AppUtils.scale(9.5.sp) ?? 12,
                ),
              ),
              avatar: filter.avatar != null
                  ? svgIcon(
                      filter.avatar!,
                      color:
                          isSelected ? Colors.white : AppColors.hintTextColor,
                    )
                  : null,
              selected: isSelected,
              showCheckmark: false,
              backgroundColor: AppColors.listTileColor,
              selectedColor: AppColors.primaryColor,
              shape: chipShape,
              onSelected: (selected) {
                if (selected) {
                  // Clear all other filters
                  explore.clearFilters();

                  // Add the selected filter
                  explore.addFilter(
                    filter,
                    _getFilterValue(filter, profileData),
                  );
                } else {
                  // Remove the filter when deselected
                  explore.removeFilter(filter);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Determine the value for each filter dynamically (e.g., from user input or defaults)
  dynamic _getFilterValue(Filters filter, CoreProfile? profileData) {
    switch (filter) {
      case Filters.similarInterest:
        return profileData?.interests ?? [];
      case Filters.outsideMyCountry:
        return profileData?.countryOfOrigin;
      case Filters.newMembers:
        return DateTime.now().subtract(const Duration(days: 7));
      case Filters.online:
        return true;
      case Filters.lookingToDate:
        return Preference.lookingToDate.index;
      default:
        return null;
    }
  }
}
