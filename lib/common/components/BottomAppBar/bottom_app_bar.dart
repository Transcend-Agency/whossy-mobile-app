import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/index.dart';
import '../../../provider/provider.dart';
import '../../styles/text_style.dart';
import '../../utils/utils.dart';

class BottomNavItem {
  final String assetPath;
  final String label;

  const BottomNavItem({required this.assetPath, required this.label});
}

class CustomBottomAppBar extends StatefulWidget {
  const CustomBottomAppBar({
    super.key,
    required this.items,
  });

  final List<BottomNavItem> items;

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  void _updatedIndex(int index) =>
      context.read<TourNotifier>().setTab(index, context);

  @override
  Widget build(BuildContext context) {
    final selectedIndex =
        context.select<TourNotifier, int>((tour) => tour.currentIndex);

    List<Widget> items = List.generate(
      widget.items.length,
      (index) {
        return _buildTabItem(
          item: widget.items[index],
          index: index,
          onPressed: _updatedIndex,
          isSelected: selectedIndex == index,
        );
      },
    );

    return BottomAppBar(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget _buildTabItem({
    required BottomNavItem item,
    required int index,
    ValueChanged<int>? onPressed,
    required bool isSelected,
  }) {
    Color? color = isSelected
        ? AppColors.selectedTabIconColor
        : AppColors.unSelectedTabIconColor;

    GlobalKey? currentKey;
    switch (index) {
      case 0:
        currentKey = GlobalKeys.globalSearchTabKey;
        break;
      case 1:
        currentKey = GlobalKeys.fireTabKey;
        break;
      case 2:
        currentKey = GlobalKeys.heartTabKey;
        break;
      case 3:
        currentKey = GlobalKeys.chatTabKey;
        break;
      case 4:
        currentKey = GlobalKeys.userTabKey;
        break;
    }

    return Expanded(
      child: SizedBox(
        child: Material(
          type: MaterialType.transparency,
          child: GestureDetector(
            onTap: () => onPressed!(index),
            child: Padding(
              padding: EdgeInsets.all(1.r),
              child: Column(
                key: currentKey,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    item.assetPath,
                    height: 23,
                    colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  ),
                  addHeight(4),
                  Text(
                    item.label,
                    style: TextStyles.prefText.copyWith(
                      color: color,
                      fontWeight: FontWeight.w500,
                      fontSize: AppUtils.scale(9.sp) ?? 11.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
