import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../utils/index.dart';

class FilledBackButton extends StatelessWidget {
  const FilledBackButton({super.key, this.onTap, this.isDisabled = false});

  final bool isDisabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: SizedBox.square(
        dimension: 46.r,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.backButtonColor,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              backIcon(),
              if (isDisabled)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.backButtonColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
