import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

final pagePadding = EdgeInsets.symmetric(horizontal: 14.w);

final circularBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(8.r),
);

const inputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: AppColors.inputBackGround),
  borderRadius: BorderRadius.all(
    Radius.circular(8),
  ),
);

final errorBorder = inputBorder.copyWith(
  borderSide: const BorderSide(
    color: AppColors.errorBorderColor,
    width: 1,
  ),
);

final enabledBorder = inputBorder.copyWith(
  borderSide: const BorderSide(
    color: Colors.transparent,
  ),
);

final focusedErrorBorder = inputBorder.copyWith(
  borderSide: BorderSide(
    color: AppColors.errorBorderColor.withOpacity(0.7),
    width: 1.5,
  ),
);
