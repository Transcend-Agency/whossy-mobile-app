import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../constants/index.dart';

class PremiumPlan extends StatelessWidget {
  const PremiumPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PlanCard(
          containerColor: AppColors.premiumContainer,
          containerShade: AppColors.premiumContainerShade,
          title: 'Premium Plan',
          amount: '12.99',
          showDetails: false,
          stops: [0, 1],
        ),
        const Expanded(child: SizedBox.shrink()),
        Padding(
          padding: EdgeInsets.only(bottom: 16.r),
          child: DialogButton(
            text: "Subscribe",
            color: AppColors.premiumContainer,
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
