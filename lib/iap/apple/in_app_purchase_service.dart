import 'dart:async';
import 'dart:developer';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../common/utils/enum/enums.dart';

class InAppPurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;

  final Set<String> _subscriptionsIds =
      SubscriptionProductIds.values.map((e) => e.name).toSet();

  final Set<String> _creditIds =
      CreditBundleIds.values.map((e) => e.name).toSet();

  bool _purchaseIsPending = false;

  bool get isPending {
    return _purchaseIsPending;
  }

  List<ProductDetails> _subscriptions = [];
  List<ProductDetails> _credits = [];

  StreamSubscription<List<PurchaseDetails>>? _subscriptionStream;
  StreamSubscription<List<PurchaseDetails>>? _creditStream;

  List<ProductDetails> get subscriptions => _subscriptions;

  List<ProductDetails> get credits => _credits;

  Future<void> initStore() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;

    //You could separate these two with separate initStore functions, (if you care about efficiency). {Subscriptions or Credits}
    //region Subscriptions
    final ProductDetailsResponse subscriptionResponse =
        await _iap.queryProductDetails(_subscriptionsIds);
    _subscriptions = subscriptionResponse.productDetails;

    _subscriptionStream = _iap.purchaseStream.listen(_handlePurchaseUpdates);
    //endregion

    //region Credits
    final ProductDetailsResponse creditResponse =
        await _iap.queryProductDetails(_creditIds);
    _credits = creditResponse.productDetails;

    _creditStream = _iap.purchaseStream.listen(_handlePurchaseUpdates);
    //endregion
  }

  Future<void> buySubscription(SubscriptionProductIds productId) async {
    final product = _subscriptions.firstWhere((p) => p.id == productId.name);
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> buyCredits(CreditBundleIds productId) async {
    final product = _credits.firstWhere((p) => p.id == productId.name);
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyConsumable(purchaseParam: purchaseParam);
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.pending:
          //TODO: Show loading state and probably deactivate the payment button to avoid duplicate transactions

          log("Purchase pending: ${purchase.productID}");
          _purchaseIsPending = true;
          break;

        case PurchaseStatus.purchased:
          //TODO: Give the user what he paid for.

          log("Purchase successful: ${purchase.productID}");
          _purchaseIsPending = false;

          _iap.completePurchase(purchase);
          break;

        case PurchaseStatus.error:
          //TODO: Show error message

          log("Purchase failed: ${purchase.error}");
          if (purchase.pendingCompletePurchase) {
            _iap.completePurchase(purchase); // This clears the cache
          }
          _purchaseIsPending = false;

          break;

        case PurchaseStatus.canceled:
          //TODO: Tell the user that he cancelled the payment

          log("Purchase canceled by user");
          _purchaseIsPending = false;

          break;

        case PurchaseStatus.restored:
          //TODO: Return the product the user paid for.
          log("Purchase canceled by user");
          _purchaseIsPending = false;

          break;
      }
    }
  }

  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  void dispose() {
    _subscriptionStream?.cancel();
    _creditStream?.cancel();
  }
}
