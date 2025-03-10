import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import 'common/components/components.dart';

void listenToPurchase(
    List<PurchaseDetails> purchaseDetailsList, BuildContext context) async {
  for (final purchaseDetails in purchaseDetailsList) {
    if (purchaseDetails.status == PurchaseStatus.pending) {
      // Handle pending purchase
      showSnackbar(
        'Pending purchase',
        context,
        snackBarType: SnackbarType.warning,
      );
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      // Handle error
    } else if (purchaseDetails.status == PurchaseStatus.purchased) {
      // Handle successful purchase
    }
  }
}
