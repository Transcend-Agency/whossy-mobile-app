import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../styles/text_style.dart';
import '../../utils/index.dart';
import '../index.dart';

class PlanCard extends StatelessWidget {
  final Color containerColor;
  final Color containerShade;
  final String title;
  final String amount;
  final List<String>? benefits;
  final VoidCallback? onSeeAllFeatures;
  final bool showDetails;
  final List<double>? stops;

  const PlanCard({
    super.key,
    required this.containerColor,
    required this.title,
    required this.amount,
    required this.containerShade,
    this.benefits,
    this.onSeeAllFeatures,
    this.showDetails = true,
    this.stops,
  }) : assert(
          showDetails == false ||
              (benefits != null && onSeeAllFeatures != null),
          'Benefits and onSeeAllFeatures must be provided when showDetails is true',
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270.r,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [containerShade, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: stops ?? const [0.1, 0.7],
        ),
        border: Border.all(
          color: containerColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.only(
        left: 10.r,
        right: 10.r,
        bottom: showDetails ? 6.r : 10.r,
        top: 10.r,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.profileHead.copyWith(
              fontSize: AppUtils.scale(14.sp) ?? 18,
              color: containerColor,
            ),
          ),
          addHeight(4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '\$ ',
                    style: TextStyles.whossyGuideText.copyWith(
                      color: containerColor,
                      fontWeight: FontWeight.w600,
                      fontSize: AppUtils.scale(12.5.sp) ?? 14.sp,
                    ),
                  ),
                  Text(
                    amount,
                    style: TextStyles.whossyGuideText.copyWith(
                      color: containerColor,
                      fontWeight: FontWeight.w600,
                      fontSize: AppUtils.scale(26.sp) ?? 30.sp,
                      height: 1,
                    ),
                  ),
                ],
              ),
              Text(
                ' /month',
                style: TextStyles.whossyGuideText.copyWith(
                  color: containerColor,
                  fontWeight: FontWeight.w600,
                  fontSize: AppUtils.scale(11.5.sp) ?? 13.sp,
                ),
              ),
            ],
          ),

          // Only show details if showDetails is true
          if (showDetails) ...[
            addHeight(16),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(benefits!.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      benefits![index],
                      style: TextStyles.chatText.copyWith(
                        fontWeight: FontWeight.w500,
                        color: containerColor,
                      ),
                    ),
                    _line(containerColor),
                    addHeight(14),
                  ],
                );
              }),
            ),
            AppButton(
              height: 40,
              onPress: onSeeAllFeatures!,
              text: 'See all features',
              color: containerColor,
            ),
          ]
        ],
      ),
    );
  }
}

Widget _line(Color color) {
  return Container(
    margin: EdgeInsets.only(top: 8.r),
    height: 1, // Height of the divider
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          color,
          Colors.white
        ], // Start with full color, end with transparent
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
  );
}
