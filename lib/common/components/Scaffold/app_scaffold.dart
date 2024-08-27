import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/utils/index.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final bool resizeToAvoidBottomInset;
  final EdgeInsetsGeometry? padding;
  final bool back;
  final bool applyTop;
  final bool useScrollView;
  final Widget? bottomNavBar;
  final PreferredSizeWidget? appBar;

  const AppScaffold({
    super.key,
    required this.body,
    this.resizeToAvoidBottomInset = false,
    this.padding,
    this.back = false,
    this.useScrollView = false,
    this.bottomNavBar,
    this.appBar,
    this.applyTop = true,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry finalPadding = padding ?? const EdgeInsets.all(0);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: appBar,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: Colors.white,
        body: SafeArea(
          top: applyTop,
          child: useScrollView
              ? SingleChildScrollView(
                  child: content(context: context, finalPadding: finalPadding),
                )
              : content(context: context, finalPadding: finalPadding),
        ),
        bottomNavigationBar: bottomNavBar,
      ),
    );
  }

  Widget content({
    required BuildContext context,
    required EdgeInsetsGeometry finalPadding,
  }) {
    return Stack(
      children: [
        if (back)
          Padding(
            padding: EdgeInsets.only(left: 6.w, top: 16.h),
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.all(6.r),
                child: backIcon(),
              ),
            ),
          ),
        Padding(
          padding: finalPadding.add(EdgeInsets.only(top: back ? 32.h : 0)),
          child: body,
        ),
      ], //
    );
  }
}
