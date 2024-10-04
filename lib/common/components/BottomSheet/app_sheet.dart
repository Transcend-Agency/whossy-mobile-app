import 'package:flutter/material.dart';

import '../../../feature/home/preferences/model/generic_enum.dart';
import '../../styles/component_style.dart';
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
    return AppSheetScaffold(
      topPadding: 16,
      title: widget.item.header,
      onExit: () => Navigator.pop(context, hasChanged ? data : null),
      exitIcon: hasChanged ? checkIcon() : cancelIcon(),
      child: Padding(
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
