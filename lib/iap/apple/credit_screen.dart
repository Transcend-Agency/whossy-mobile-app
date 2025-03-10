import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/components.dart';
import 'package:whossy_app/iap/apple/in_app_purchase_service.dart';

import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/services/payment/nomba/nomba_web_page.dart';
import '../../../../../common/utils/services/payment/paystack/paystack_web_page.dart';
import '../../../../../common/utils/services/services.dart'
    hide InAppPurchaseService;
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/provider.dart';

@RoutePage()
class Credits extends StatefulWidget {
  const Credits({super.key});

  @override
  State<Credits> createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  final InAppPurchaseService iap = InAppPurchaseService();
  CreditBundleIds? selectedCredit;

  @override
  void dispose() {
    iap.dispose();
    super.dispose();
  }

  @override
  void initState() {
    initializeService();
    super.initState();
  }

  Future<void> initializeService() async {
    await iap.initStore();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const CustomAppBar(
        addBarHeight: 4,
        title: 'Whossy Credits',
        color: Colors.white,
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
                        "Unlock conversations with Whossy credits!",
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
                  children: List.generate(iap.credits.length, (index) {
                    ProductDetails credit = iap.credits[index];

                    return GenericTile(
                      unselectedBorderColor: AppColors.outlinedColor,
                      tileColor: Colors.white,
                      bottom: 14.r,
                      value: credit,
                      groupValue: null,
                      onChanged: (newEnum) {},
                      title: credit.title,
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addHeight(3),
                          Text(
                            credit.price,
                            style: TextStyles.profileHead.copyWith(
                              fontSize: AppUtils.scale(12.sp) ?? 15,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
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
                    onPressed: () async =>
                        await iap.buyCredits(CreditBundleIds.credit100),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  // /// Helper method to format the price with commas
  // String formatPrice(Credit quantity, Currency userCurrency) {
  //   final price = quantity.getPrice(userCurrency).round();
  //   return '${NumberFormat('#,##0').format(price)} ${userCurrency.toString().split('.').last}';
  // }

  Future<void> pay({
    required BuildContext context,
    required String currency,
    required double amount,
    required int quantity,
  }) async {
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

    if (currency == 'NGN' || currency == 'KES') {
      navigateToPaystackPayment(
        context: context,
        email: editNotifier.coreProfile!.email!,
        currency: currency,
        amount: amount,
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
  }
}
