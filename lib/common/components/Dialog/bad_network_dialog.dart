import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../constants/index.dart';
import '../../styles/text_style.dart';
import '../../utils/index.dart';

class BadNetworkDialog extends StatefulWidget {
  const BadNetworkDialog({
    super.key,
    this.title = 'Network error',
    this.subtitle = AppStrings.errorDataFetch,
    this.padding,
  });

  final String title;
  final String subtitle;
  final EdgeInsets? padding;

  @override
  State<BadNetworkDialog> createState() => _BadNetworkDialogState();
}

class _BadNetworkDialogState extends State<BadNetworkDialog>
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
      child: Padding(
        padding: widget.padding ?? EdgeInsets.symmetric(horizontal: 30.r),
        child: Column(
          children: [
            const Spacer(flex: 4),
            SizedBox.square(
              dimension: 240.r,
              child: Lottie.asset(
                AppAssets.badNetwork,
                controller: _controller,
                onLoaded: onLoaded,
              ),
            ),
            Text(
              widget.title,
              style: TextStyles.profileHead.copyWith(
                fontSize: AppUtils.scale(14.5.sp) ?? 24,
              ),
            ),
            addHeight(4),
            Text(
              widget.subtitle,
              style: TextStyles.hintThemeText.copyWith(
                fontSize: AppUtils.scale(11.sp) ?? 14.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 6),
          ],
        ),
      ),
    );
  }
}
