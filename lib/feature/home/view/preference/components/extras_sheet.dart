import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/feature/home/model/extras.dart';

import '../../../../../common/components/index.dart';
import '../../../../../common/styles/component_style.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../constants/index.dart';

class ExtrasSheet<T extends GenericEnum> extends StatefulWidget {
  const ExtrasSheet({super.key, required this.item, this.selectedItem});

  final ExtraPreferences<T> item;
  final T? selectedItem;

  @override
  State<ExtrasSheet<T>> createState() => _ExtrasSheetState<T>();
}

class _ExtrasSheetState<T extends GenericEnum> extends State<ExtrasSheet<T>> {
  late T? data;
  bool hasChanged = false;

  // Example groupValue and onChanged function
  void onChanged(T? value) {
    setState(() {
      hasChanged = data != value;
      if (hasChanged) data = value;
    });
  }

  @override
  void initState() {
    data = widget.selectedItem;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.item.header,
                  style: TextStyles.buttonText.copyWith(
                    fontSize: AppUtils.scale(17),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context, hasChanged ? data : null),
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
          addHeight(18)
        ],
      ),
    );
  }
}
