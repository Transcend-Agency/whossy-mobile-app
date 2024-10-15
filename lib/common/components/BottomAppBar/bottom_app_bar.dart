import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/index.dart';

class CustomBottomAppBar extends StatefulWidget {
  const CustomBottomAppBar({
    super.key,
    required this.onTabSelected,
    required this.items,
  });

  final ValueChanged<int> onTabSelected;
  final List<String> items;

  @override
  State<CustomBottomAppBar> createState() => _CustomBottomAppBarState();
}

class _CustomBottomAppBarState extends State<CustomBottomAppBar> {
  int _selectedIndex = 0;

  // Update Index
  _updatedIndex(int index) {
    widget.onTabSelected(index);
    setState(
      () => _selectedIndex = index,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Generated a list of the Items for the BottomNavBar
    List<Widget> items = List.generate(
      widget.items.length,
      (index) {
        return _buildTabItem(
          item: widget.items[index],
          index: index,
          onPressed: _updatedIndex,
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
    required String item,
    required int index,
    ValueChanged<int>? onPressed,
  }) {
    Color? color = _selectedIndex == index
        ? AppColors.selectedTabIconColor
        : AppColors.unSelectedTabIconColor;

    return Expanded(
      child: SizedBox(
        child: Material(
          type: MaterialType.transparency,
          child: GestureDetector(
            onTap: () => onPressed!(index),
            child: Padding(
              padding: EdgeInsets.all(12.r),
              child: SvgPicture.asset(
                item,
                height: 25,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
