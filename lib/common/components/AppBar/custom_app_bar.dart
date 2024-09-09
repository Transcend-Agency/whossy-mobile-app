import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.showAction = true,
    this.action,
    this.onPop,
  });

  final String title;
  final bool showAction;
  final Widget? action;
  final Future<void> Function()? onPop;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.outlinedColor, width: 1),
        ),
      ),
      child: AppBar(
        backgroundColor: AppColors.inputBackGround,
        surfaceTintColor: AppColors.inputBackGround,
        titleSpacing: 0,
        leading: GestureDetector(
          onTap: () async {
            if (onPop != null) {
              await onPop!();
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            margin: EdgeInsets.only(
              left: 10.w,
            ),
            child: const Icon(
              Icons.arrow_back_ios,
              size: 22,
            ),
          ),
        ),
        actions: [if (action != null) action!],
        title: Text(
          title,
          style: TextStyles.boldPrefText,
        ),
      ),
    );
  } //
}
