import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../constants/index.dart';
import '../../../data/state/user_search_notifier.dart';

/// The name search box at the top of Explore.
class ExploreSearchBar extends HookWidget {
  const ExploreSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final search = context.read<UserSearchNotifier>();
    // Keeps the box in step with the notifier, which outlives this widget
    // (the term survives opening a profile and coming back).
    final controller = useTextEditingController(text: search.term);
    final hasText = context.select<UserSearchNotifier, bool>((s) => s.term.isNotEmpty);

    return Container(
      height: 44.h,
      decoration: BoxDecoration(
        color: AppColors.listTileColor,
        borderRadius: BorderRadius.circular(100),
      ),
      padding: EdgeInsets.only(left: 14.w, right: 4.w),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 20.r, color: AppColors.hintTextColor),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: search.updateTerm,
              maxLength: 60,
              textInputAction: TextInputAction.search,
              textCapitalization: TextCapitalization.words,
              autocorrect: false,
              enableSuggestions: false,
              cursorColor: AppColors.black,
              style: TextStyles.hintThemeText.copyWith(color: AppColors.black),
              decoration: InputDecoration(
                hintText: 'Search people by name',
                hintStyle: TextStyles.hintThemeText.copyWith(color: AppColors.hintTextColor),
                // The app theme fills form fields and gives them rounded
                // enabled/focused borders; `border` alone doesn't override
                // those, which drew a tinted box inside the pill.
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isDense: true,
                counterText: '',
              ),
            ),
          ),
          if (hasText)
            IconButton(
              tooltip: 'Clear search',
              visualDensity: VisualDensity.compact,
              icon: Icon(Icons.close_rounded, size: 20.r, color: AppColors.hintTextColor),
              onPressed: () {
                controller.clear();
                search.clear();
                FocusScope.of(context).unfocus();
              },
            ),
        ],
      ),
    );
  }
}
