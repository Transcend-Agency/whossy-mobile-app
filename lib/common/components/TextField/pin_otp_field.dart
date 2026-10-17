import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../constants/index.dart';

class PinOTPField extends StatefulWidget {
  const PinOTPField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  State<PinOTPField> createState() => _PinOTPFieldState();
}

class _PinOTPFieldState extends State<PinOTPField> {
  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      mainAxisAlignment: MainAxisAlignment.center,
      appContext: context,
      length: 6,
      controller: widget.controller,
      onChanged: (text) {},
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      autoFocus: true,
      cursorColor: AppColors.black,
      pinTheme: PinTheme(
        fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 4),
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        fieldHeight: 54.h,
        fieldWidth: 50.25.w,
        activeFillColor: AppColors.inputBackGround,
        activeColor: Colors.transparent,
        selectedColor: AppColors.selectedFieldColor,
        selectedFillColor: AppColors.inputBackGround,
        inactiveFillColor: AppColors.inputBackGround,
        inactiveColor: Colors.transparent,
        borderWidth: 0,
        selectedBorderWidth: 1,
        activeBorderWidth: 0,
        inactiveBorderWidth: 0,
      ),
      textStyle: TextStyle(
        fontFamily: 'NeueMontreal',
        fontSize: 20.sp,
        fontWeight: FontWeight.w400,
      ),
      backgroundColor: Colors.white,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      beforeTextPaste: (text) => true,
    );
  }
}
