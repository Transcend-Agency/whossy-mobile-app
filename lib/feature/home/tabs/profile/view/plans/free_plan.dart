import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../constants/index.dart';

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
        const Expanded(child: SizedBox.shrink()),
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
