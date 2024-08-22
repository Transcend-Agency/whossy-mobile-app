import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/styles/text_style.dart';

import '../../../constants/colors.dart';
import '../../styles/component_style.dart';
import '../widget_functions.dart';

class AppTheme {
  ThemeData theme() {
    return ThemeData(
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
        ),
      ),
      outlinedButtonTheme: const OutlinedButtonThemeData(style: ButtonStyle()),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.white,
      ),
      // Configure the input decoration theme for form fields.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        hintStyle: TextStyles.hintThemeText,
        errorStyle: TextStyles.errorStyle,
        enabledBorder: inputBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,
        disabledBorder: inputBorder,
        border: inputBorder,
        focusedBorder: focusedBorder,
      ),
      sliderTheme: SliderThemeData(
        thumbColor: AppColors.black,
        activeTrackColor: AppColors.outlinedColor,
        inactiveTrackColor: AppColors.outlinedColor,
        overlayShape: SliderComponentShape.noOverlay,
        trackHeight: 1,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: switchThumbColor,
        trackOutlineColor: switchTrackOutlineColor,
        trackColor: switchTrackColor,
      ),
    );
  }

  CountryListThemeData countryListTheme({TextStyle? textStyle}) {
    return CountryListThemeData(
      flagSize: 22,
      backgroundColor: Colors.white,
      textStyle: textStyle ??
          TextStyles.fieldHeader.copyWith(
            color: AppColors.hintTextColor,
          ),
      searchTextStyle:
          TextStyles.hintThemeText.copyWith(color: AppColors.black),
      bottomSheetHeight: ScreenUtil().screenHeight * 0.62,
      borderRadius: circularTop,
      inputDecoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: AppColors.inputBackGround.withOpacity(0.6),
        hintStyle: TextStyles.hintThemeText,
        hintText: 'Search country',
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 3.w, right: 1.w),
          child: search(),
        ),
        focusedBorder: inputBorder
          ..borderSide.copyWith(
            color: AppColors.selectedFieldColor,
          ),
      ),
    );
  }
}
