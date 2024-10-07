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
            child: AppButton(
              color: AppColors.listTileColor,
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.unMatch, height: 22),
                  addWidth(10),
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
            padding: EdgeInsets.symmetric(vertical: 12.r, horizontal: 14.r),
            child: AppButton(
              color: AppColors.listTileColor,
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.blockUser, height: 26),
                  addWidth(10),
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
            child: AppButton(
              color: AppColors.listTileColor,
              onPress: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppAssets.report, height: 26),
                  addWidth(10),
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
