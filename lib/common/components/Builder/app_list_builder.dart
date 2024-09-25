import 'package:flutter/material.dart';

class AppListBuilder extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const AppListBuilder({
    super.key,
    required this.padding,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
