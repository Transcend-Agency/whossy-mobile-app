import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:whossy_app/common/utils/extensions.dart';
import 'package:whossy_app/common/utils/services/payment/paystack/service/paystack_payment_service.dart';
import 'package:whossy_app/feature/auth/sign_up/model/payment.dart';

import '../../../../constants/index.dart';
import '../../../../provider/provider.dart';
import '../../../components/Snackbar/app_snackbar.dart';
import 'paystack/model/paystack_user.dart';

class PaymentService {
  final EditProfileNotifier editNotifier;
  final PaystackPaymentService paystackPaymentService;

  PaymentService(this.editNotifier, this.paystackPaymentService);

  Future<void> onPremiumUnsubscribe(BuildContext context) async {
    final customerId = editNotifier.coreProfile?.paystackUser?.customerId;

    if (customerId == null) {
      showSnackbar('Customer id is missing!', context);
      return;
    }

    // Step 1: Update local profile to set isPremium as false
    editNotifier.updateProfile(isPremium: false);

    // Step 2: Attempt to save updated profile
    bool success = await editNotifier.saveUserProfile(
      showSnackbar: (msg) => showSnackbar(msg, context),
    );

    if (!success) {
      editNotifier.updateProfile(isPremium: true);
      if (context.mounted) {
        showSnackbar(AppStrings.payPremiumFailure, context);
      }

      return;
    }

    // Step 3: Get subscriptions for the customer
    try {
      List<Map<String, dynamic>> subscriptions =
          await paystackPaymentService.getSubscriptionsForCustomer(customerId);

      if (subscriptions.isEmpty && context.mounted) {
        showSnackbar('No active subscriptions found!', context);
        return;
      }

      // Step 4: Unsubscribe from all active subscriptions
      for (var subscription in subscriptions) {
        String subscriptionCode = subscription['subscription_code'];
        String emailToken = subscription['email_token'];

        // Call the unsubscribe method
        await paystackPaymentService.unsubscribe(
          subscriptionCode: subscriptionCode,
          emailToken: emailToken,
        );
      }

      // Step 5: Confirm successful unsubscription and show snackbar
      if (context.mounted) {
        showSnackbar(
          'Successfully unsubscribed from premium!',
          context,
          snackBarType: SnackbarType.success,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackbar('Unsubscription failed! Please try again.', context);
      }
    }
  }

  Future<void> onPremiumSuccess(
    BuildContext context, {
    required Map<String, dynamic> response,
    required String currency,
    int? index,
  }) async {
    // Extract values
    final bool overallStatus = response['status'] ?? false;
    final Map<String, dynamic>? paystackUserMap = response['paystack_user'];

    // Handle failure early
    if (!overallStatus || paystackUserMap == null) {
      showSnackbar(AppStrings.errorUnknown, context);
      return;
    }

    // Notify success
    showSnackbar(
      'Payment completed successfully!',
      context,
      snackBarType: SnackbarType.success,
    );

    final bool isPremiumUser = editNotifier.coreProfile?.isPremium ?? false;
    final int? currentPlan = editNotifier.coreProfile?.currentPlan;
    final PaystackUser? paystackUser = editNotifier.coreProfile?.paystackUser;

    // Update and save
    editNotifier.updateProfile(
      isPremium: true,
      currentPlan: index,
      paystackUser: PaystackUser.fromJson(paystackUserMap),
    );

    final bool success = await editNotifier.saveUserProfile(
      showSnackbar: (msg) => showSnackbar(msg, context),
    );

    if (!success) {
      editNotifier.updateProfile(
        isPremium: isPremiumUser,
        currentPlan: currentPlan,
        paystackUser: paystackUser,
      );
      if (context.mounted) showSnackbar(AppStrings.payPremiumFailure, context);
    }
  }

  /// Handles post-payment failure operations
  void onPremiumFailure(
    BuildContext context,
    String errMessage,
    String reason,
  ) {
    showSnackbar(errMessage, context, snackBarType: SnackbarType.error);
    debugPrint("==> Payment failed: $reason");

    // Additional failure handling logic
  }

  /// Handles post-payment success operations
  Future<void> onCreditSuccess(
    BuildContext context, {
    required int credit,
    required Map<String, dynamic> response,
    required String currency,
    required double amount,
  }) async {
    log("===> Payment Successful \n${response.formatJson()}");

    // Check if the payment data contains a success status
    final bool overallStatus = response['status'] ?? false;

    if (overallStatus) {
      showSnackbar(
        'Payment completed successfully!',
        context,
        snackBarType: SnackbarType.success,
      );

      var creditBalance = (editNotifier.coreProfile?.creditBalance ?? 0);
      var paymentBalance = (editNotifier.coreProfile?.amountPaid ?? Payment());

      // Preserve the original values to revert in case of failure
      var originalPaymentBalance = Payment.fromJson(paymentBalance.toJson());

      // Check the currency and update the payment balance accordingly
      if (currency == 'KES') {
        paymentBalance.updatePayment(kshIncrement: amount); // Increment KSH
      } else if (currency == 'NGN') {
        paymentBalance.updatePayment(ngnIncrement: amount); // Increment NGN
      } else if (currency == 'USD') {
        paymentBalance.updatePayment(usdIncrement: amount); // Increment USD
      }

      editNotifier.updateProfile(
        creditBalance: creditBalance + credit,
        amountPaid: paymentBalance,
      );

      bool success = await editNotifier.saveUserProfile(
        showSnackbar: (msg) => showSnackbar(msg, context),
      );

      if (!success) {
        editNotifier.updateProfile(
          creditBalance: creditBalance,
          amountPaid: originalPaymentBalance,
        );
        if (context.mounted) {
          showSnackbar(AppStrings.addCreditsFailure, context);
        }

        return;
      }
    } else {
      showSnackbar(
        AppStrings.errorUnknown,
        context,
        snackBarType: SnackbarType.warning,
      );
    }
  }

  /// Handles post-payment failure operations
  void onCreditFailure(
    BuildContext context,
    String errMessage,
    String reason,
  ) {
    showSnackbar(errMessage, context, snackBarType: SnackbarType.warning);
    debugPrint("==> Payment failed: $reason, \n Error Message: $errMessage");

    // Additional failure handling logic
  }
}
