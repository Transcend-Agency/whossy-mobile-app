import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/data/state/onboarding_notifier.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';

class DistanceScreen extends StatefulWidget {
  final int pageIndex;
  const DistanceScreen({super.key, required this.pageIndex});

  @override
  State<DistanceScreen> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen>
    with AutomaticKeepAliveClientMixin<DistanceScreen> {
  late OnboardingNotifier onboardingProvider;
  final _debouncer = Debouncer(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    onboardingProvider =
        Provider.of<OnboardingNotifier>(context, listen: false);
  }

  double distance = 50;
  double outRadius = 137.5;
  double inRadius = 120;

  void updateRadii(double external, double internal) {
    setState(() {
      outRadius = external;
      inRadius = internal;
    });
  }

  void onChanged(double newValue) {
    double mapExt = (newValue / 100) * (175 - 100) + 100;
    double mapInt = (newValue / 100) * (170 - 70) + 70;

    updateRadii(mapExt, mapInt);

    setState(() => distance = newValue);

    _debouncer.run(
        () => onboardingProvider.updateUserProfile(search: distance.toInt()));

    final valid = newValue >= 1;

    if (onboardingProvider.isSelected(widget.pageIndex) != valid) {
      onboardingProvider.select(widget.pageIndex, value: valid);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const OnboardingHeaderText(
          title: "Distance search radius",
          subtitle: AppStrings.distanceSubHeader,
        ),
        const Spacer(),
        Stack(
          alignment: Alignment.center,
          children: [
            Ring(
              externalRadius: outRadius,
              internalRadius: inRadius,
            ),
            Container(
              width: 144,
              height: 144,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.listTileColor,
              ),
              child: Center(
                child: Text(
                  '${distance.toInt()} mi',
                  style: TextStyles.title.copyWith(fontSize: 24.sp),
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Padding(
          padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 90.h),
          child: Slider.adaptive(
            value: distance,
            onChanged: onChanged,
            min: 0,
            max: 100,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
