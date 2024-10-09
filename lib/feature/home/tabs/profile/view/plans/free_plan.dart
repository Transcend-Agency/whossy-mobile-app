import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/feature/home/tabs/profile/view/widgets/sub_container.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../data/source/subscription_plan_data.dart';

class FreePlan extends StatelessWidget {
  const FreePlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PlanCard(
          containerColor: AppColors.freeContainer,
          containerShade: AppColors.freeContainerShade,
          title: 'Whossy Free Plan',
          amount: '0',
          showDetails: false,
          stops: [0, 1],
        ),
        addHeight(12),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: freePlanData.map((sub) {
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
            color: AppColors.freeContainer,
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
