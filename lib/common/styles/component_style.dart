import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';

final pagePadding = EdgeInsets.symmetric(horizontal: 14.w);

final modalPadding = EdgeInsets.symmetric(vertical: 13.h, horizontal: 16.w);

final forgotTouchable = EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w);

const verifyTouchable = EdgeInsets.all(6);

final circularTop = BorderRadius.vertical(top: Radius.circular(14.r));

// Use it in RoundedRectangleBorder
final roundedTop = RoundedRectangleBorder(borderRadius: circularTop);

final circularBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(8.r),
);

const curvySide = BorderRadius.all(Radius.circular(12));

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

final switchThumbColor = WidgetStateProperty.resolveWith<Color?>(
  (Set<WidgetState> states) {
    return AppColors.inputBackGround;
  },
);

final switchTrackOutlineColor = WidgetStateProperty.resolveWith<Color?>(
  (Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return Colors.green;
    }
    return Colors.black;
  },
);

final switchTrackColor = WidgetStateProperty.resolveWith<Color?>(
  (Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return Colors.green;
    }
    return Colors.black;
  },
);
