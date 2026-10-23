import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/utils/utils.dart';

/// Widest a form or list page gets on a large screen.
const double kMaxContentWidth = 640;

class AppScaffold extends StatelessWidget {
  final Widget body;
  final bool resizeToAvoidBottomInset;
  final EdgeInsetsGeometry? padding;
  final bool back;
  final bool applyTop;
  final bool useScrollView;

  /// Lays the body out at least as tall as the visible area, so a `Spacer`
  /// still pushes content down, and scrolls once the body is taller — such
  /// as when the keyboard is up. Needs `resizeToAvoidBottomInset: true` to
  /// see the keyboard, and a body without lazily built lists.
  final bool fillViewportAndScroll;
  final Widget? bottomNavBar;
  final PreferredSizeWidget? appBar;

  /// Widest the body gets before it is centred with space either side, so
  /// forms and lists keep a phone's proportions on a tablet. Null lets the
  /// body fill the screen, for pages built around a photo or a grid.
  final double? maxContentWidth;

  const AppScaffold({
    super.key,
    required this.body,
    this.resizeToAvoidBottomInset = false,
    this.padding,
    this.back = false,
    this.useScrollView = false,
    this.fillViewportAndScroll = false,
    this.bottomNavBar,
    this.appBar,
    this.applyTop = true,
    this.maxContentWidth = kMaxContentWidth,
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
          child: _limitWidth(
            fillViewportAndScroll
                ? LayoutBuilder(
                    builder: (context, constraints) => SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: content(
                              context: context, finalPadding: finalPadding),
                        ),
                      ),
                    ),
                  )
                : useScrollView
                    ? SingleChildScrollView(
                        child: content(
                            context: context, finalPadding: finalPadding),
                      )
                    : content(context: context, finalPadding: finalPadding),
          ),
        ),
        bottomNavigationBar: bottomNavBar,
      ),
    );
  }

  Widget _limitWidth(Widget child) {
    final max = maxContentWidth;
    if (max == null) return child;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: max),
        child: child,
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
