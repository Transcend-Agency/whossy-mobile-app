import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class SubscriptionBilling<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final ValueChanged<T?> onChanged;
  final String title;
  final String price;
  final String discountInfo;
  final String billingCycle;
  final Color selectedBorderColor;
  final Color selectedShade;

  const SubscriptionBilling({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.title,
    required this.price,
    required this.discountInfo,
    required this.billingCycle,
    this.selectedBorderColor = AppColors.premiumContainer,
    this.selectedShade = AppColors.premiumContainerShade,
  });

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Container(
        width: 230.w,
        padding: EdgeInsets.all(16.r),
        margin: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [selectedShade, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.1, 0.7],
                )
              : null,
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? selectedBorderColor : AppColors.outlinedColor,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: selectedBorderColor.withOpacity(0.2),
                blurRadius: 6,
                spreadRadius: 2,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row with custom radio button and text
            Row(
              children: [
                Container(
                  width: 17.r,
                  height: 17.r,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedBorderColor.withOpacity(0.85)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? Colors.transparent : Colors.grey,
                      width: 1.5,
                    ),
                  ),
                ),
                addWidth(12),
                Text(
                  title,
                  style: TextStyles.profileHead.copyWith(
                    fontSize: AppUtils.scale(15.sp) ?? 19,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            addHeight(6),

            Padding(
              padding: EdgeInsets.only(bottom: 4.h),
              child: line(
                isSelected ? selectedBorderColor : AppColors.outlinedColor,
              ),
            ),

            addHeight(8),

            // Row with price and discount info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "$price / mo",
                  style: TextStyles.profileHead.copyWith(
                    fontSize: AppUtils.scale(14.sp) ?? 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Text(
                //   discountInfo,
                //   style: TextStyle(
                //     fontSize: 14.sp,
                //     color: Colors.green,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            ),

            SizedBox(height: 6.h),

            // Billing cycle text
            Text(
              billingCycle,
              style: TextStyles.hintThemeText.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: AppUtils.scale(10.sp) ?? 13.5.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
