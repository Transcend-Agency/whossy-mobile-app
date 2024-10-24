import 'package:flutter/material.dart';

import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../model/explore_search.dart';

class ExploreFilters extends StatefulWidget {
  const ExploreFilters({super.key});

  @override
  State<ExploreFilters> createState() => _ExploreFiltersState();
}

class _ExploreFiltersState extends State<ExploreFilters> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 6,
      children: List.generate(options.length, (index) {
        final explore = options[index];
        return ChoiceChip(
          label: Text(
            explore.label,
            style: TextStyles.prefText.copyWith(
              color: selectedIndex == index
                  ? Colors.white
                  : AppColors.hintTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          avatar: explore.avatar != null
              ? svgIcon(
                  explore.avatar!,
                  color: selectedIndex == index
                      ? Colors.white
                      : AppColors.hintTextColor,
                )
              : null,
          selected: selectedIndex == index,
          showCheckmark: false,
          backgroundColor: AppColors.listTileColor,
          selectedColor: AppColors.primaryColor,
          shape: chipShape,
          onSelected: (selected) {
            setState(() => selectedIndex = selected ? index : -1);
          },
        );
      }),
    );
  }
}
