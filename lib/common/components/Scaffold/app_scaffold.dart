import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final bool resizeToAvoidBottomInset;
  final EdgeInsetsGeometry? padding;
  final bool back;

  const AppScaffold({
    super.key,
    required this.body,
    this.resizeToAvoidBottomInset = false,
    this.padding,
    this.back = false,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry finalPadding = padding ?? const EdgeInsets.all(0);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Stack(
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
                padding:
                    finalPadding.add(EdgeInsets.only(top: back ? 28.h : 0)),
                child: body,
              ),
            ], //
          ),
        ),
      ),
    );
  }
}
