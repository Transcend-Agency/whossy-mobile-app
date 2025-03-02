import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../common/components/components.dart';
import '../../../../common/utils/utils.dart';
import '../../../../constants/index.dart';
import '../data/state/onboarding_notifier.dart';

class VerifyPhotoScreen extends StatefulWidget {
  final int pageIndex;

  const VerifyPhotoScreen({super.key, required this.pageIndex});

  @override
  State<VerifyPhotoScreen> createState() => _VerifyPhotoScreenState();
}

class _VerifyPhotoScreenState extends State<VerifyPhotoScreen>
    with AutomaticKeepAliveClientMixin<VerifyPhotoScreen> {
  late OnboardingNotifier onboardingProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    onboardingProvider = context.read<OnboardingNotifier>();

    // Defer the update to the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onboardingProvider.select(widget.pageIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        addHeight(48),
        Row(
          children: [
            SizedBox.square(
              dimension: 82.r,
              child: Image.asset(AppAssets.verifiedTick),
            ),
          ],
        ),
        addHeight(12),
        const OnboardingHeaderText(
          title: "Get photo verified",
          subtitle:
              'To confirm you’re who you, we’d like to do a photo verification to confirm you’re the person in your photos.',
        ),
        addHeight(24),
        const Spacer(),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
