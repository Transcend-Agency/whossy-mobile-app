import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:whossy_app/feature/home/edit_profile/data/state/edit_profile_notifier.dart';
import 'package:whossy_app/feature/home/tabs/profile/model/credit.dart';
import 'package:whossy_app/feature/home/tabs/profile/view/widgets/currency_sheet.dart';

import '../../../../../../common/components/index.dart';
import '../../../../../../common/utils/index.dart';
import '../../../../../../common/utils/services/services.dart';
import '../../../../../../constants/index.dart';
import '../../data/source/subscription_plan_data.dart';
import '../widgets/sub_container.dart';

class PremiumPlan extends StatelessWidget {
  const PremiumPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PlanCard(
          containerColor: AppColors.premiumContainer,
          containerShade: AppColors.premiumContainerShade,
          title: 'Premium Plan',
          amount: '9.99',
          showDetails: false,
          stops: [0, 1],
        ),
        addHeight(12),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: premiumPlanData.map((sub) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
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
        Selector<EditProfileNotifier, bool>(
          selector: (_, edit) => edit.coreProfile?.isPremium ?? false,
          builder: (_, isPremium, __) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DialogButton(
                text: isPremium ? "Cancel Plan" : "Subscribe",
                color: AppColors.premiumContainer,
                textColor: Colors.white,
                onPressed: isPremium
                    ? () => cancelPlan(context)
                    : () => showCurrencySheet(
                          context,
                          onPay: (currency) =>
                              pay(context: context, currency: currency),
                        ),
              ),
            );
          },
        ),
      ],
    );
  }

  // Adjusted method to return Future<bool?>?
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
  }) async {
    if (currency.name != 'NGN') {
      showSnackbar(
        '${currency.name} Payment is coming soon',
        context,
        snackBarType: SnackbarType.warning,
      );
      return;
    }

    final editNotifier = context.read<EditProfileNotifier>();
    final paymentService = PaymentService(editNotifier);

    await PayWithPayStack().now(
      context: context,
      secretKey: "sk_test_b9688554e5b6a393c6d74c2b8e30d5ba36e7fafe",
      customerEmail: editNotifier.coreProfile!.email!,
      reference: const Uuid().v4(),
      currency: currency.name,
      amount: 15000,
      callbackUrl: "https://google.com",
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
