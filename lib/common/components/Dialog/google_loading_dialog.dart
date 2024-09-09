import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/index.dart';

class GoogleLoadingDialog extends StatefulWidget {
  const GoogleLoadingDialog({super.key});

  @override
  State<GoogleLoadingDialog> createState() => _GoogleLoadingDialogState();
}

class _GoogleLoadingDialogState extends State<GoogleLoadingDialog>
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
        AppAssets.googleLoading,
        controller: _controller,
        onLoaded: onLoaded,
        // height: 500,
        //  width: 500,
      ),
    );
  }
}

void showGoogleDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Center(
      child: GoogleLoadingDialog(),
    ),
  );
}
