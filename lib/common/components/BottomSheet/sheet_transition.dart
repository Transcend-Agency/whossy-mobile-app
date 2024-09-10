import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/component_style.dart';

class _CupertinoBottomSheetContainer extends StatelessWidget {
  final Widget? child;
  final Color? backgroundColor;

  /// Add padding to the top of [child], this is also the height of visible
  /// content behind [child]
  ///
  /// Defaults to 10
  const _CupertinoBottomSheetContainer({
    this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final topSafeAreaPadding = MediaQuery.of(context).padding.top;
    final topPadding = 16 + topSafeAreaPadding;
    final radius = Radius.circular(14.r);
    const shadow = BoxShadow(
      blurRadius: 10,
      color: Colors.black12,
      spreadRadius: 5,
    );
    final backgroundColor = this.backgroundColor ??
        CupertinoTheme.of(context).scaffoldBackgroundColor;

    final decoration = BoxDecoration(
      color: backgroundColor,
      boxShadow: const [shadow],
    );

    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
        child: Container(
          decoration: decoration,
          width: double.infinity,
          child: MediaQuery.removePadding(
            context: context,
            removeTop: true, // Remove top Safe Area
            child: child!,
          ),
        ),
      ),
    );
  }
}

class CupertinoModalTransition extends StatelessWidget {
  /// Animation that [child] will use for entry or leave
  final Animation<double> animation;

  /// Animation curve to be applied to [animation]
  ///
  /// Defaults to [Curves.easeOut]
  final Curve? animationCurve;

  /// Widget that will be displayed at the top
  final Widget child;

  /// Widget that will be displayed behind [child]
  ///
  /// Usually this is the route that shows this model
  final Widget behindChild;

  const CupertinoModalTransition({
    super.key,
    required this.animation,
    required this.child,
    required this.behindChild,
    this.animationCurve,
  });

  @override
  Widget build(BuildContext context) {
    var startRoundCorner = 0.0;
    final paddingTop = MediaQuery.of(context).padding.top;
    if (Theme.of(context).platform == TargetPlatform.iOS && paddingTop > 20) {
      startRoundCorner = 38.5;
    }

    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: animationCurve ?? Curves.easeOut,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      /// Because the first element of the stack below is a black coloured
      /// container, this is required
      value: SystemUiOverlayStyle.light,
      child: AnimatedBuilder(
        animation: curvedAnimation,
        child: child,
        builder: (context, child) {
          final progress = curvedAnimation.value;
          final yOffset = progress * paddingTop;
          final scale = 1 - progress / 10;
          final radius = progress == 0
              ? 0.0
              : (1 - progress) * startRoundCorner + progress * 12;
          return Stack(
            children: [
              GestureDetector(
                onTap: Navigator.of(context).pop,
                child: Container(color: Colors.black),
              ),
              GestureDetector(
                onTap: Navigator.of(context).pop,
                child: Transform.translate(
                  offset: Offset(0, yOffset),
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topCenter,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: behindChild,
                    ),
                  ),
                ),
              ),
              child!,
            ],
          );
        },
      ),
    );
  }
}

class CupertinoDialogBody extends StatefulWidget {
  final Widget child;
  const CupertinoDialogBody({
    super.key,
    required this.child,
  });

  @override
  State<CupertinoDialogBody> createState() => _CupertinoDialogBodyState();
}

class _CupertinoDialogBodyState extends State<CupertinoDialogBody> {
  /// Prevent further popping of navigator stack once dialog is popped
  bool isDialogPopped = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 1,
      minChildSize: 0.6,
      builder: (context, controller) {
        return _CupertinoBottomSheetContainer(
          backgroundColor: Colors.white,
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (DraggableScrollableNotification notification) {
              if (!isDialogPopped &&
                  notification.extent == notification.minExtent) {
                isDialogPopped = true;
                Navigator.of(context).pop();
              }
              return false;
            },
            child: CupertinoApp(
              debugShowCheckedModeBanner: false,
              home: Container(
                color: Colors.white,
                child: Stack(
                  children: [
                    Padding(padding: pagePadding, child: widget.child),
                    Positioned(
                      top: 20.h,
                      left: 8.w,
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(10.r),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
