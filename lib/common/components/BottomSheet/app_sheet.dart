import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../../feature/home/preferences/model/generic_enum.dart';
import '../../styles/component_style.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';
import '../index.dart';

class AppSheet<T extends GenericEnum> extends StatefulWidget {
  const AppSheet({super.key, required this.item, this.selectedItem});

  final CorePreferencesData<T> item;
  final T? selectedItem;

  @override
  State<AppSheet<T>> createState() => _AppSheetState<T>();
}

class _AppSheetState<T extends GenericEnum> extends State<AppSheet<T>> {
  late T? data;
  late T? store;
  bool hasChanged = false;

  void onChanged(T? value) {
    setState(() {
      if (data != value) {
        data = value;
      }
      hasChanged = data != store;
    });
  }

  @override
  void initState() {
    data = widget.selectedItem;

    store = data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
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
                    widget.item.header,
                    style: TextStyles.boldPrefText,
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pop(context, hasChanged ? data : null),
                    child: SizedBox.square(
                      dimension: 30.r,
                      child: hasChanged ? checkIcon() : cancelIcon(),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: AppColors.outlinedColor,
              height: 0,
            ),
            addHeight(16),
            Padding(
              padding: pagePadding,
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: widget.item.items.map((item) {
                  return PreferenceChip<T?>(
                    value: item.value,
                    groupValue: data,
                    onChanged: onChanged,
                    title: item.text,
                  );
                }).toList(),
              ),
            ),
            addHeight(14)
          ],
        ),
      ),
    );
  }
}

Future<T?> showCustomModalBottomSheet<T extends GenericEnum>({
  required BuildContext context,
  required CorePreferencesData<T> item,
  T? selectedItem,
}) {
  return showModalBottomSheet<T?>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => AppSheet<T>(item: item, selectedItem: selectedItem),
  );
}
