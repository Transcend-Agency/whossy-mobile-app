import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/index.dart';
import '../../utils/utils.dart';

class LoadingDialog extends StatefulWidget {
  final String animation;

  const LoadingDialog({super.key, required this.animation});

  @override
  State<LoadingDialog> createState() => _LoadingDialogState();
}

class _LoadingDialogState extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  _animationUpdate(AnimationStatus stats) {
    if (stats == AnimationStatus.completed) {
      _controller.reset();
      _controller.forward();
    }
  }

  onLoaded(LottieComposition composition) {
    _controller
      ..duration = composition.duration
      ..forward();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addStatusListener(_animationUpdate);
    // _controller.value = 0.5;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        widget.animation,
        controller: _controller,
        onLoaded: onLoaded,
        decoder: customDecoder,
      ),
    );
  }
}

/// Shows the loading dialog and returns a function that closes it.
///
/// The returned function removes this dialog's own route, wherever it sits
/// in the stack, and does nothing once the dialog is gone, so it is safe to
/// call more than once. Close it before navigating away rather than popping
/// afterwards: a pop takes whatever is on top, which by then may be the next
/// screen or, when no dialog was shown, the screen underneath.
VoidCallback showLoadingDialog(
  BuildContext context, {
  String animation = AppAssets.googleLoading,
}) {
  final navigator = Navigator.of(context, rootNavigator: true);
  final route = DialogRoute<void>(
    context: context,
    barrierDismissible: false,
    // As showDialog builds it, so the dialog looks the same as before.
    barrierColor: DialogTheme.of(context).barrierColor ??
        Theme.of(context).dialogTheme.barrierColor ??
        Colors.black54,
    traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
    themes: InheritedTheme.capture(from: context, to: navigator.context),
    builder: (context) => Center(
      child: LoadingDialog(animation: animation),
    ),
  );
  navigator.push(route);

  return () {
    if (route.isActive) navigator.removeRoute(route);
  };
}
