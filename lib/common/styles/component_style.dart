import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/colors.dart';
import '../utils/index.dart';

final pagePadding = EdgeInsets.symmetric(horizontal: 14.r);

const chatFieldPadding = EdgeInsets.fromLTRB(10, 5, 10, 10);

final modalPadding = EdgeInsets.symmetric(
  vertical: 10.r,
  horizontal: 14.r,
).copyWith(
  top: AppUtils.scale(12),
  bottom: AppUtils.scale(12),
);

final forgotTouchable = EdgeInsets.symmetric(vertical: 6.h, horizontal: 2.w);

const verifyTouchable = EdgeInsets.all(6);

final circularTop = BorderRadius.vertical(top: Radius.circular(14.r));

// Use it in RoundedRectangleBorder
final roundedTop = RoundedRectangleBorder(borderRadius: circularTop);

final guidelineSheetDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1), // Shadow color
      blurRadius: 10,
      offset: const Offset(0, -4),
    ),
  ],
);

final matchButtonShadow = BoxShadow(
  color: Colors.black.withOpacity(0.1),
  blurRadius: 10,
  offset: const Offset(0, 4),
);

final circularBorder = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(8.r),
);

final chipShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(24.r),
  side: const BorderSide(color: Colors.transparent),
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

final editMediaDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.r),
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

/// The border for the input fields
InputBorder customBorder({
  required bool isReplying,
  double curve = 20,
}) {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.transparent,
    ),
    borderRadius: BorderRadius.vertical(
      top: isReplying ? Radius.zero : Radius.circular(curve.r),
      bottom: Radius.circular(curve.r),
    ),
  );
}

// Updated bubbleDecoration function
BoxDecoration bubbleDecoration(
  bool isSender,
  bool isPreviousSameSender,
  bool isNextSameSender,
) {
  final isSingleMessage = !isPreviousSameSender && !isNextSameSender;

  return BoxDecoration(
    color: isSender ? const Color(0XFFE5F2FF) : AppColors.listTileColor,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(
          isSender ? 14.r : (isPreviousSameSender ? 4.r : 14.r)),
      topRight: Radius.circular(
          isSender ? (isPreviousSameSender ? 4.r : 14.r) : 14.r),
      bottomLeft: Radius.circular(isSender
          ? 14.r
          : isSingleMessage
              ? 0.r
              : (isNextSameSender ? 4.r : 14.r)),
      bottomRight: Radius.circular(isSender
          ? (isSingleMessage ? 0.r : (isNextSameSender ? 4.r : 14.r))
          : 14.r),
    ),
  );
}
