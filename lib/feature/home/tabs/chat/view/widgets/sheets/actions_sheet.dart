import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../common/components/index.dart';
import '../../../../../../../common/styles/component_style.dart';
import '../../../../../../../common/styles/text_style.dart';
import '../../../../../../../common/utils/index.dart';
import '../../../../../../../constants/index.dart';

class ActionsSheet extends StatelessWidget {
  final String name;

  const ActionsSheet({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return AppSheetScaffold(
      title: 'Actions',
      topPadding: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: pagePadding,
            child: OutlinedAppButton(
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  svgIcon(AppAssets.unMatch),
                  addWidth(6),
                  Text(
                    "Unmatch $name",
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 14.w),
            child: OutlinedAppButton(
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  svgIcon(AppAssets.unMatch),
                  addWidth(8),
                  Text(
                    "Block $name",
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: pagePadding,
            child: OutlinedAppButton(
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  svgIcon(AppAssets.unMatch),
                  addWidth(4),
                  Text(
                    "Report $name",
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                      color: AppColors.buttonColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void showActionsSheet(BuildContext context, String name) {
  showModalBottomSheet<void>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => ActionsSheet(name: name),
  );
}
