import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/styles/component_style.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.showAction = true,
    this.action,
    this.onPop,
    this.color,
    this.automaticallyImplyLeading = true,
    this.borderColor,
  }) : assert(title != null || titleWidget != null,
            'Either title or titleWidget must be provided.');

  final String? title;
  final Widget? titleWidget;
  final bool showAction;
  final Widget? action;
  final Color? color;
  final Color? borderColor;
  final Future<void> Function()? onPop;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: borderColor ?? AppColors.outlinedColor,
            width: 1,
          ),
        ),
      ),
      child: AppBar(
        backgroundColor: color ?? AppColors.inputBackGround,
        surfaceTintColor: color ?? AppColors.inputBackGround,
        titleSpacing: 0,
        leading: automaticallyImplyLeading
            ? GestureDetector(
                onTap: () async {
                  if (onPop != null) {
                    await onPop!();
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10.w),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ),
                ),
              )
            : null,
        actions: [if (action != null) action!],
        title: Padding(
          padding: automaticallyImplyLeading ? EdgeInsets.zero : pagePadding,
          child: titleWidget ??
              Text(
                title!,
                style: TextStyles.boldPrefText,
              ),
        ),
      ),
    );
  }
}
