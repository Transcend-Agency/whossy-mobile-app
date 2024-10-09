import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../data/source/subscription_plan_data.dart';
import '../widgets/sub_container.dart';

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
        addHeight(12),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: premiumPlanData.map((sub) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SubscriptionContainer(
                    title: sub.title,
                    feature: sub.feature,
                    chipText: sub.type,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
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
