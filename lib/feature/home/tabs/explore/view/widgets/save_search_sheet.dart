import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class SaveSearchSheet extends StatefulWidget {
  const SaveSearchSheet({super.key});

  @override
  State<SaveSearchSheet> createState() => _SaveSearchSheetState();
}

class _SaveSearchSheetState extends State<SaveSearchSheet> {
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: modalPadding.copyWith(
              top: AppUtils.scale(12.h),
              bottom: AppUtils.scale(12.h),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Save search',
                  style: TextStyles.buttonText.copyWith(
                    fontSize: AppUtils.scale(17),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: SizedBox.square(
                    dimension: 30.r,
                    child: cancelIcon(),
                  ),
                ),
              ],
            ),
          ),
          const AppDivider(),
          addHeight(12),
          Padding(
            padding: pagePadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "You can save this search by adding a name below and clicking save",
                  style: TextStyles.prefText
                      .copyWith(color: AppColors.hintTextColor),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 2,
                        child: AppTextField(
                          action: TextInputAction.done,
                          focusNode: searchFocusNode,
                          textController: searchController,
                          hintText: 'saved search name',
                          onFieldSubmitted: (email) {},
                          padding: 13,
                        ),
                      ),
                      addWidth(12),
                      Expanded(
                        child: DialogButton(
                          padding: 12.h,
                          text: 'Save',
                          color: AppColors.buttonColor,
                          textColor: Colors.white,
                          onPressed: null,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: DialogButton(
                        padding: 12.h,
                        text: 'Continue without saving',
                        color: AppColors.listTileColor,
                        textColor: AppColors.hintTextColor,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          addHeight(14)
        ],
      ),
    );
  }
}

Future<void> showSaveSearchSheet({
  required BuildContext context,
}) {
  return showModalBottomSheet(
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => const SaveSearchSheet(),
  );
}
