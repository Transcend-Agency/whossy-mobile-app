import 'package:flutter/material.dart';
import 'package:whossy_app/feature/auth/sign_up/model/payment.dart';

import '../../../../constants/index.dart';
import '../../../../provider/providers.dart';
import '../../../components/Snackbar/app_snackbar.dart';

class PaymentService {
  final EditProfileNotifier editNotifier;

  PaymentService(this.editNotifier);

  Future<void> onPremiumUnsubscribe(BuildContext context) async {
    editNotifier.updateProfile(isPremium: false);

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
//
    // if (context.mounted) Navigator.of(context).pop();
  }

  Future<void> onPremiumSuccess(
    BuildContext context, {
    required Map<String, dynamic> response,
    required String currency,
  }) async {
    final bool overallStatus = response['status'] ?? false;
    final String? dataStatus = response['data']?['status'];

    if (overallStatus && dataStatus == 'success') {
      showSnackbar(
        'Payment completed successfully!',
        context,
        snackBarType: SnackbarType.success,
      );

      bool isPremiumUser = editNotifier.coreProfile?.isPremium ?? false;

      editNotifier.updateProfile(isPremium: true);

      bool success = await editNotifier.saveUserProfile(
        showSnackbar: (msg) => showSnackbar(msg, context),
      );

      if (!success) {
        editNotifier.updateProfile(isPremium: isPremiumUser);
        if (context.mounted) {
          showSnackbar(AppStrings.payPremiumFailure, context);
        }

        return;
      }

      if (context.mounted) Navigator.of(context).pop();
    } else {
      showSnackbar(
        AppStrings.errorUnknown,
        context,
        snackBarType: SnackbarType.success,
      );
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
    // log("===> Payment Successful\n${response.formatJson()}");

    // Check if the payment data contains a success status
    final bool overallStatus = response['status'] ?? false;
    final String? dataStatus = response['data']?['status'];

    if (overallStatus && dataStatus == 'success') {
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
        snackBarType: SnackbarType.success,
      );
    }
  }

  /// Handles post-payment failure operations
  void onCreditFailure(
    BuildContext context,
    String errMessage,
    String reason,
  ) {
    showSnackbar(errMessage, context, snackBarType: SnackbarType.error);
    debugPrint("==> Payment failed: $reason");

    // Additional failure handling logic
  }
}
