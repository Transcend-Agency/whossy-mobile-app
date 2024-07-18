import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constants/index.dart';
import '../../utils/index.dart';

class FilledBackButton extends StatelessWidget {
  const FilledBackButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox.square(
        dimension: 46.r,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.backButtonColor,
          ),
          //padding: const EdgeInsets.all(8),
          child: backIcon(),
        ),
      ),
    );
  }
}
