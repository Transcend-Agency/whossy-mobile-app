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

void showLoadingDialog(
  BuildContext context, {
  String animation = AppAssets.googleLoading,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: LoadingDialog(animation: animation),
    ),
  );
}
