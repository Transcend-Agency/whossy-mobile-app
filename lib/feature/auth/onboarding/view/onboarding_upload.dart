import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/component_style.dart';
import '../../../../constants/index.dart';

class OnboardingUpload extends StatefulWidget {
  const OnboardingUpload({super.key});

  @override
  State<OnboardingUpload> createState() => _OnboardingUploadState();
}

class _OnboardingUploadState extends State<OnboardingUpload>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.repeat();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  onLoaded(LottieComposition composition) {
    // Configure the AnimationController with the duration of the
    // Lottie file and start the animation.
    _controller
      ..duration = composition.duration
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: pagePadding.copyWith(top: 12.h),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            const SignupHeaderText(
              center: true,
              top: 6,
              title: "All set and ready 🔥",
              subtitle:
                  "We are setting up your profile  and getting your match ready :)",
            ),
            Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: Lottie.asset(
                AppAssets.loading,
                controller: _controller,
                decoder: customDecoder,
                onLoaded: onLoaded,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<LottieComposition?> customDecoder(List<int> bytes) {
  return LottieComposition.decodeZip(bytes, filePicker: (files) {
    return files.firstWhereOrNull(
        (f) => f.name.startsWith('animations/') && f.name.endsWith('.json'));
  });
}
