import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/components/index.dart';
import '../../../../common/styles/text_style.dart';
import '../../../../constants/index.dart';

// Todo : Wrap this up
class DistanceScreen extends StatefulWidget {
  final int pageIndex;
  const DistanceScreen({super.key, required this.pageIndex});

  @override
  State<DistanceScreen> createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  double distance = 50;
  double outRadius = 117;
  double inRadius = 70; // Correct initial internal radius

  void updateRadii(double external, double internal) {
    setState(() {
      outRadius = external;
      inRadius = internal.clamp(0.0, external);
    });
  }

  void onChanged(double newValue) {
    // Map the slider value from 0-100 to 100-175
    double mapRadius = (newValue / 100) * (175 - 100) + 100;

    // Calculate the internal radius based on the slider value
    //double newInternalRadius = mapRadius - (45 * (1 - (newValue / 100)) + 5);

    updateRadii(mapRadius, 92.5);

    setState(() {
      distance = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              internalRadius: 70,
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
          padding: EdgeInsets.fromLTRB(8.w, 0, 8.w, 80.h),
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
}
