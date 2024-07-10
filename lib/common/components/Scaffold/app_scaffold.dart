import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final bool resizeToAvoidBottomInset;
  final EdgeInsetsGeometry? padding;

  const AppScaffold({
    super.key,
    required this.body,
    this.resizeToAvoidBottomInset = false,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: padding ?? const EdgeInsets.all(0),
            child: body,
          ),
        ),
      ),
    );
  }
}
