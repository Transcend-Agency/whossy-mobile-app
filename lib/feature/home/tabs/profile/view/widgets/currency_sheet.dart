import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/styles/component_style.dart';
import '../../../../../../common/styles/text_style.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../constants/index.dart';
import '../../model/credit.dart';

class CurrencySheet extends HookWidget {
  const CurrencySheet({super.key, required this.onPay});

  final Future<void> Function(Currency) onPay;

  @override
  Widget build(BuildContext context) {
    final userCurrency = useState<Currency>(Currency.USD);

    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment options',
                    style: TextStyles.buttonText.copyWith(
                      fontSize: AppUtils.scale(17),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SizedBox.square(
                      dimension: 30.r,
                      child: cancelIcon(),
                    ),
                  )
                ],
              ),
            ),
            const AppDivider(),
            addHeight(14),
            Padding(
              padding: pagePadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: Currency.values.map((currency) {
                  return GenericTile<Currency>(
                    addTrailingColor: true,
                    unselectedBorderColor: AppColors.outlinedColor,
                    selectedBorderColor: AppColors.premiumContainer,
                    tileColor: Colors.white,
                    bottom: 14.r,
                    value: currency,
                    groupValue: userCurrency.value,
                    onChanged: (newEnum) => userCurrency.value = newEnum!,
                    title: '${currency.paymentText} (${currency.name})',
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: pagePadding.copyWith(bottom: 14),
              child: DialogButton(
                text: "Pay",
                color: AppColors.premiumContainer,
                textColor: Colors.white,
                onPressed: () async => await onPay(userCurrency.value),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showCurrencySheet(
  BuildContext context, {
  required Future<void> Function(Currency) onPay,
}) {
  showModalBottomSheet<void>(
    clipBehavior: Clip.hardEdge,
    context: context,
    shape: roundedTop,
    builder: (_) => CurrencySheet(onPay: onPay),
  );
}
