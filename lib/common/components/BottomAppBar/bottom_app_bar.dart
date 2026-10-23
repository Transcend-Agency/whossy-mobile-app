import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/index.dart';
import '../../../provider/provider.dart';
import '../../styles/text_style.dart';
import '../../utils/utils.dart';

/// Height of the floating pill itself, excluding its outer margins.
const double kFloatingNavHeight = 64;

const Duration kNavSlideDuration = Duration(milliseconds: 280);

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

    return Container(
      height: kFloatingNavHeight,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(kFloatingNavHeight),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / widget.items.length;
          return Stack(
            children: [
              // One highlight shared by all tabs, so it glides to the newly
              // selected tab instead of each tab fading on and off.
              AnimatedPositioned(
                duration: kNavSlideDuration,
                curve: Curves.easeOutCubic,
                left: tabWidth * selectedIndex + 2,
                top: 0,
                bottom: 0,
                width: tabWidth - 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color:
                        AppColors.selectedTabIconColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(kFloatingNavHeight),
                  ),
                ),
              ),
              Row(children: items),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabItem({
    required BottomNavItem item,
    required int index,
    ValueChanged<int>? onPressed,
    required bool isSelected,
  }) {
    final Color color = isSelected
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
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onPressed!(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          alignment: Alignment.center,
          child: TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: color),
            duration: kNavSlideDuration,
            builder: (context, animatedColor, _) => Column(
              key: currentKey,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fixed box so icons of different shapes (the heart is taller)
                // line up across tabs.
                SizedBox.square(
                  dimension: 24,
                  child: SvgPicture.asset(
                    item.assetPath,
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                        animatedColor ?? color, BlendMode.srcIn),
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    item.label,
                    maxLines: 1,
                    style: TextStyles.prefText.copyWith(
                      color: animatedColor ?? color,
                      fontWeight: FontWeight.w500,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
