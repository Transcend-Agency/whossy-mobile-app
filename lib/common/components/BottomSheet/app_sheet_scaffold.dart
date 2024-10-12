import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/component_style.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';
import '../Divider/app_divider.dart';

class AppSheetScaffold extends StatelessWidget {
  const AppSheetScaffold({
    super.key,
    this.useBottomInsets = false,
    required this.title,
    this.canPop = true,
    required this.child,
    this.padding,
    this.onExit,
    this.exitIcon,
    this.topPadding,
    this.bottomPadding,
  });

  final bool useBottomInsets;
  final bool canPop;
  final String title;
  final Widget child;
  final Widget? exitIcon;
  final double? topPadding;
  final double? bottomPadding;
  final EdgeInsets? padding;
  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context) {
    return useBottomInsets
        ? content(context)
        : SafeArea(child: content(context));
  }

  Widget content(BuildContext context) {
    return Container(
      padding: useBottomInsets
          ? EdgeInsets.only(
              bottom: MediaQuery.viewInsetsOf(context).bottom,
            )
          : null,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: modalPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyles.buttonText.copyWith(
                    fontSize: AppUtils.scale(17),
                  ),
                ),
                GestureDetector(
                  onTap: onExit ?? () => Navigator.pop(context),
                  child: SizedBox.square(
                    dimension: 30.r,
                    child: exitIcon ?? cancelIcon(),
                  ),
                ),
              ],
            ),
          ),
          const AppDivider(),
          addHeight(topPadding ?? 12),
          child,
          addHeight(bottomPadding ?? 14)
        ],
      ),
    );
  }
}
