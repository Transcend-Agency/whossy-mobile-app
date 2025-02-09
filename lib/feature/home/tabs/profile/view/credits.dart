import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';
import 'package:whossy_app/common/utils/services/payment/nomba/nomba_web_page.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/index.dart';
import '../../../../../common/utils/services/services.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/providers.dart';
import '../model/credit.dart';
import 'widgets/_.dart';

@RoutePage()
class Credits extends HookWidget {
  const Credits({super.key});

  @override
  Widget build(BuildContext context) {
    final creditValue = useState<Credit?>(null);
    final userCurrency = useState<Currency>(Currency.USD);

    return AppScaffold(
      appBar: CustomAppBar(
        addBarHeight: 4,
        title: 'Whossy Credits',
        color: Colors.white,
        action: Padding(
          padding: EdgeInsets.only(right: 20.r),
          child: CurrencyDropdown(
            selectedCurrency: userCurrency.value,
            onCurrencyChanged: (newCurrency) {
              if (newCurrency != null) {
                userCurrency.value = newCurrency;
              }
            },
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 14.r, right: 14.r, top: 16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.yellowContainer,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(14.r),
              child: Center(
                child: Column(
                  children: [
                    SizedBox.square(
                      dimension: 80.r,
                      child: Image.asset(
                        AppAssets.credit2,
                      ),
                    ),
                    addHeight(6),
                    Text(
                      'Whossy Credits',
                      textAlign: TextAlign.center,
                      style: TextStyles.title.copyWith(
                        fontSize: AppUtils.scale(32) ?? 26,
                      ),
                    ),
                    addHeight(8),
                    Opacity(
                      opacity: 0.9,
                      child: Text(
                        'Buy credits to boost profile and get more visibility on Whossy',
                        textAlign: TextAlign.center,
                        style: TextStyles.hintThemeText.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: AppUtils.scale(10.sp) ?? 13.5.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            addHeight(20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: credits.map((quantity) {
                    return GenericTile(
                      unselectedBorderColor: AppColors.outlinedColor,
                      tileColor: Colors.white,
                      bottom: 14.r,
                      value: quantity,
                      groupValue: creditValue.value,
                      onChanged: (newEnum) => creditValue.value = newEnum,
                      title: '${quantity.quantity} Credits',
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addHeight(3),
                          Text(
                            '${quantity.getPrice(userCurrency.value)} ${userCurrency.value.toString().split('.').last}',
                            style: TextStyles.profileHead.copyWith(
                              fontSize: AppUtils.scale(12.sp) ?? 15,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Selector<ConnectivityNotifier, bool>(
              selector: (_, connection) => connection.isConnected,
              builder: (_, isConnected, __) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: DialogButton(
                    text: "Continue",
                    color: AppColors.buttonColor,
                    textColor: Colors.white,
                    onPressed: creditValue.value == null
                        ? null
                        : isConnected
                            ? () async => await pay(
                                  quantity: creditValue.value!.quantity,
                                  context: context,
                                  currency: userCurrency.value
                                      .toString()
                                      .split('.')
                                      .last,
                                  amount: creditValue.value!
                                      .getPrice(userCurrency.value),
                                )
                            : () =>
                                showSnackbar(AppStrings.deviceOffline, context),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> pay({
    required BuildContext context,
    required String currency,
    required double amount,
    required int quantity,
  }) async {
    if (currency == 'KES') {
      showSnackbar(
        '$currency Payment is coming soon',
        context,
        snackBarType: SnackbarType.warning,
      );
      return;
    }

    final editNotifier = context.read<EditProfileNotifier>();
    final paymentService = PaymentService(editNotifier);

    if (currency == 'USD') {
      navigateToUSDPayment(
        context: context,
        email: editNotifier.coreProfile!.email!,
        currency: currency,
        amount: amount,
        customerId: FirebaseAuth.instance.currentUser!.uid,
        transactionCompleted: (response) => paymentService.onCreditSuccess(
          context,
          credit: quantity,
          response: response,
          currency: currency,
          amount: amount,
        ),
        transactionNotCompleted: (errType, reason) =>
            paymentService.onCreditFailure(context, errType.message, reason),
      );
    }

    // await PayWithPayStack().now(
    //   context: context,
    //   secretKey: "sk_test_b9688554e5b6a393c6d74c2b8e30d5ba36e7fafe",
    //   customerEmail: editNotifier.coreProfile!.email!,
    //   reference: const Uuid().v4(),
    //   currency: currency,
    //   amount: amount,
    //   callbackUrl: "https://google.com",
    //   transactionCompleted: (response) => paymentService.onCreditSuccess(
    //     context,
    //     credit: quantity,
    //     response: response,
    //     currency: currency,
    //     amount: amount,
    //   ),
    //   transactionNotCompleted: (errType, reason) =>
    //       paymentService.onCreditFailure(context, errType.message, reason),
    // );
  }
}

void navigateToUSDPayment({
  required BuildContext context,
  required String email,
  required String currency,
  required double amount,
  required String customerId,
  required TransactionCompletedCallback transactionCompleted,
  required TransactionNotCompletedCallback transactionNotCompleted,
}) {
  Nav.push(
    context,
    NombaWebRoute(
      email: email,
      currency: currency,
      amount: amount,
      customerId: customerId,
      transactionCompleted: transactionCompleted,
      transactionNotCompleted: transactionNotCompleted,
    ),
  );
}
