import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';

class CoreSettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isPremium;
  final bool showDivider;
  final bool switchValue;
  final ValueChanged<bool> onSwitchChanged;

  const CoreSettingsTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isPremium,
    this.showDivider = true,
    required this.switchValue,
    required this.onSwitchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.r, top: 10.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: TextStyles.prefText,
                      ),
                      addWidth(12),
                      if (isPremium)
                        Container(
                          padding: EdgeInsets.only(
                            bottom: 1.h,
                            left: 8.w,
                            right: 8.w,
                          ),
                          decoration: const BoxDecoration(
                            borderRadius: curvySide,
                            gradient: AppColors.splashVariation,
                          ),
                          child: Text(
                            'Premium',
                            style: TextStyles.prefText.copyWith(
                              color: Colors.white,
                              fontSize: AppUtils.scale(10.5.sp) ?? 12.sp,
                            ),
                          ),
                        )
                    ],
                  ),
                  addHeight(8),
                  SizedBox(
                    width: ScreenUtil().screenWidth * 0.75,
                    child: Text(
                      subtitle,
                      style: TextStyles.prefText
                          .copyWith(color: AppColors.hintTextColor),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3.r),
                child: Transform.scale(
                  scale: 0.7,
                  child: Switch.adaptive(
                    value: switchValue,
                    onChanged: onSwitchChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          const Divider(
            color: AppColors.outlinedColor,
            height: 0,
          ),
      ],
    );
  }
}
