import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

final pagePadding = EdgeInsets.symmetric(horizontal: 14.w);

final forgotTouchable = EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w);

const verifyTouchable = EdgeInsets.all(6);

final roundedTop = RoundedRectangleBorder(
  borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
);

final circularTop = BorderRadius.only(
  topLeft: Radius.circular(12.r),
  topRight: Radius.circular(12.r),
);

final circularBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(8.r),
);

const curvySide = BorderRadius.all(Radius.circular(14));

const inputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent),
  borderRadius: BorderRadius.all(Radius.circular(8)),
);

const underlinedInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: AppColors.outlinedColor, width: 1),
);

final errorBorder = inputBorder.copyWith(
  borderSide: const BorderSide(
    color: AppColors.errorBorderColor,
    width: 1,
  ),
);

final focusedErrorBorder = inputBorder.copyWith(
  borderSide: BorderSide(
    color: AppColors.errorBorderColor.withOpacity(0.7),
    width: 1.5,
  ),
);

final snackbarDecoration = BoxDecoration(
  color: AppColors.sbErrorFillColor,
  borderRadius: BorderRadius.circular(8.r),
  border: Border.all(
    width: 1,
    color: AppColors.sbErrorBorderColor,
  ),
);

final focusedBorder = inputBorder.copyWith(
  borderSide: const BorderSide(
    color: AppColors.selectedFieldColor,
    width: 1,
  ),
);
