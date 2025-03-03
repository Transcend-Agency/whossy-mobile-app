import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/utils.dart';
import '../../model/credit.dart';

class CurrencyDropdown extends HookWidget {
  final Currency selectedCurrency;
  final ValueChanged<Currency?> onCurrencyChanged;

  const CurrencyDropdown({
    super.key,
    required this.selectedCurrency,
    required this.onCurrencyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButton<Currency>(
        borderRadius: BorderRadius.circular(10.r),
        value: selectedCurrency,
        hint: Text(
          selectedCurrency.name,
          style: TextStyles.pageHeader.copyWith(
            color: Colors.black,
            fontSize: AppUtils.scale(16) ?? 14,
          ),
        ),
        underline: const SizedBox.shrink(),
        items:
            Currency.values.map<DropdownMenuItem<Currency>>((Currency value) {
          return DropdownMenuItem<Currency>(
            value: value,
            child: Text(
              value.name,
              style: TextStyles.pageHeader.copyWith(
                color: Colors.black,
                fontSize: AppUtils.scale(16) ?? 14,
              ),
            ),
          );
        }).toList(),
        onChanged: onCurrencyChanged,
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.black,
        ),
        elevation: 2,
        dropdownColor: Colors.white,
      ),
    );
  }
}
