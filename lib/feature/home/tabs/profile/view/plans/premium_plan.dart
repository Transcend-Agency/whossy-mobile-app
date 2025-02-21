import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/services/payment/nomba/nomba_web_page.dart';
import '../../../../../../common/utils/services/payment/paystack/paystack_web_page.dart';
import '../../../../../../common/utils/services/services.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/providers.dart';
import '../../data/source/subscription_plan_data.dart';
import '../../model/credit.dart';
import '../../model/subscription_plan.dart';
import '../widgets/_.dart';
import '../widgets/sub_container.dart';

class PremiumPlan extends HookWidget {
  const PremiumPlan({super.key, required this.userCurrency});

  final ValueNotifier<Currency> userCurrency;

  @override
  Widget build(BuildContext context) {
    final selectedPlan = useState<SubscriptionPlan>(subscriptionPlans[0]);

    return ValueListenableBuilder<Currency>(
      valueListenable: userCurrency,
      builder: (context, selectedCurrency, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            addHeight(4),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  addWidth(14),
                  ...subscriptionPlans.map(
                    (plan) => Padding(
                      padding: EdgeInsets.only(right: 12.r),
                      child: SubscriptionBilling(
                        title: "${plan.duration} Plan",
                        price: plan.getPriceFormatted(selectedCurrency),
                        discountInfo: plan.discountInfo,
                        billingCycle: plan.billingCycle,
                        value: plan,
                        groupValue: selectedPlan.value,
                        onChanged: (newPlan) => selectedPlan.value = newPlan!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.r),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: premiumPlanData.map((sub) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: SubscriptionContainer(
                          title: sub.title,
                          feature: sub.feature,
                          chipText: sub.type,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Selector2<EditProfileNotifier, ConnectivityNotifier,
                Map<String, bool>>(
              selector: (_, edit, connection) => {
                "isPremium": edit.coreProfile?.isPremium ?? false,
                "isConnected": connection.isConnected,
              },
              builder: (_, values, __) {
                final isPremium = values["isPremium"]!;
                final isConnected = values["isConnected"]!;

                return Padding(
                  padding:
                      EdgeInsets.only(bottom: 14.r, left: 14.r, right: 14.r),
                  child: DialogButton(
                    text: isPremium ? "Cancel Plan" : "Subscribe",
                    color: AppColors.premiumContainer,
                    textColor: Colors.white,
                    onPressed: () {
                      if (isPremium) {
                        cancelPlan(context);
                      } else if (!isConnected) {
                        showSnackbar(AppStrings.deviceOffline, context);
                      } else {
                        pay(
                          context: context,
                          currency: selectedCurrency,
                          selectedPlan: selectedPlan.value,
                        );
                      }
                    },
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  Future<bool?>? cancelPlan(BuildContext context) async {
    bool? result = await showConfirmationDialog(
      context,
      title: 'Confirm Plan Cancellation',
      content: contentText(AppStrings.cancelPlan),
      yes: 'Yes, Cancel',
      no: 'No, Go Back',
    );

    if (result == null) return null;

    if (result && context.mounted) {
      final editNotifier = context.read<EditProfileNotifier>();
      final paymentService = PaymentService(editNotifier);
      paymentService.onPremiumUnsubscribe(context);
    }

    return result;
  }

  Future<void> pay({
    required BuildContext context,
    required Currency currency,
    required SubscriptionPlan selectedPlan,
  }) async {
    final editNotifier = context.read<EditProfileNotifier>();
    final paymentService = PaymentService(editNotifier);

    double amount = selectedPlan.getPrice(currency); // Dynamically set price

    if (currency == Currency.USD) {
      navigateToUSDPayment(
        context: context,
        email: editNotifier.coreProfile!.email!,
        currency: currency.name,
        amount: amount,
        customerId: FirebaseAuth.instance.currentUser!.uid,
        transactionCompleted: (response) => paymentService.onPremiumSuccess(
          context,
          response: response,
          currency: currency.name,
        ),
        transactionNotCompleted: (errType, reason) =>
            paymentService.onPremiumFailure(context, errType.message, reason),
      );
    }

    if (currency == Currency.NGN || currency == Currency.KES) {
      navigateToPaystackPayment(
        context: context,
        email: editNotifier.coreProfile!.email!,
        currency: currency.name,
        amount: amount,
        transactionCompleted: (response) => paymentService.onPremiumSuccess(
          context,
          response: response,
          currency: currency.name,
        ),
        transactionNotCompleted: (errType, reason) =>
            paymentService.onPremiumFailure(context, errType.message, reason),
      );
    }
  }
}
