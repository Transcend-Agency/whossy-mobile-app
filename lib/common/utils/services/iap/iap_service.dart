import 'dart:async';
import 'dart:developer';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:whossy_app/feature/home/tabs/profile/model/subscription_plan.dart';

import '../../../../feature/home/tabs/profile/model/credit.dart';
import 'purchase_verifier.dart';

class IAPService {
  IAPService._();

  static final _instance = IAPService._();

  static IAPService get instance => _instance;

  final _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _purchasesSubscription;

  /// Replaced in tests. Purchases are only honoured after this says granted.
  PurchaseVerifier verifier = FunctionsPurchaseVerifier();

  // ✅ Cache for product metadata
  final Map<String, ProductDetails> _productDetailsMap = {};

  final Set<String> _kIds = {
    ...credits.map((c) => c.productId),
    ...subscriptionPlans.map((s) => s.productId),
  };

  Set<ProductDetails> creditProducts = {};

  /// Why the last product load came back short, for the credits screen.
  String? productLoadIssue;
  Set<ProductDetails> subscriptionProducts = {};

  Future<void> initialize() async {
    if (await _iap.isAvailable()) {
      // Setup the subscription stream
      _purchasesSubscription = _iap.purchaseStream.listen(
        (purchaseDetailsList) {
          handlePurchaseUpdates(purchaseDetailsList);
        },
        onDone: () {
          _purchasesSubscription.cancel();
        },
        onError: (error) {
          _purchasesSubscription.cancel();
        },
      );

      updateAvailableProducts();
    }
  }

  Future<void> updateAvailableProducts() async {
    if (!await _iap.isAvailable()) {
      productLoadIssue =
          'The app store is not available on this device. Make sure you are '
          'signed in to the Play Store / App Store and try again.';
      return;
    }

    final response = await _iap.queryProductDetails(_kIds);
    productLoadIssue = response.error != null
        ? 'The store returned an error: ${response.error!.message}'
        : response.productDetails.isEmpty
            ? 'The store has no credit packs for this build. Install the app '
                'from the Play Store / TestFlight (not a local build) with a '
                'tester account.'
            : null;
    if (response.error != null) log('Store query error: ${response.error}');

    // Keep whatever the store returned. Waiting for every id to be found meant
    // one missing product (say a subscription not yet set up in the Play
    // Console) emptied the credit packs too.
    if (response.notFoundIDs.isNotEmpty) {
      log('Store products not found: ${response.notFoundIDs}');
    }

    // Sort all products by price ascending first
    final sortedProducts = response.productDetails.toList()
      ..sort((a, b) => a.rawPrice.compareTo(b.rawPrice));

    // Filter products for credits
    creditProducts = sortedProducts
        .where((product) => credits.any((c) => c.productId == product.id))
        .toSet();

    // Filter products for subscriptions
    subscriptionProducts = sortedProducts
        .where((product) =>
            subscriptionPlans.any((s) => s.productId == product.id))
        .toSet();
  }

  /// Whether the purchase flow started. False when the store could not find
  /// the product or threw, so the caller can tell the user.
  Future<bool> buyConsumableProduct(String productId) async {
    try {
      final response = await _iap.queryProductDetails({productId});
      if (response.notFoundIDs.isNotEmpty) {
        log('Product not found: $productId');
        return false;
      }

      final product = response.productDetails.first;
      _productDetailsMap[product.id] = product;

      final purchaseParam = PurchaseParam(productDetails: product);

      return await _iap.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );
    } catch (e) {
      log('Error buying consumable: $e');
      return false;
    }
  }

  Future<void> buySubscription(String productId) async {
    try {
      final response = await _iap.queryProductDetails({productId});
      if (response.notFoundIDs.isNotEmpty) {
        log('Subscription not found: $productId');
        return;
      }

      final product = response.productDetails.first;
      _productDetailsMap[product.id] = product;

      final purchaseParam = PurchaseParam(productDetails: product);

      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      log('Error buying subscription: $e');
    }
  }

  Future<void> purchaseProduct(
    String productId, {
    required bool isConsumable,
  }) async {
    if (isConsumable) {
      await buyConsumableProduct(productId);
    } else {
      await buySubscription(productId);
    }
  }

  void handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchase in purchaseDetailsList) {
      try {
        switch (purchase.status) {
          case PurchaseStatus.pending:
            // Optionally show a loading UI
            break;

          case PurchaseStatus.purchased:
          case PurchaseStatus.restored:
            // The server checks the purchase with Google and grants it. The
            // app does not give itself anything.
            final result = await verifier.verify(
              productId: purchase.productID,
              purchaseToken: purchase.verificationData.serverVerificationData,
            );

            if (shouldCompletePurchase(result)) {
              if (purchase.pendingCompletePurchase) {
                await _iap.completePurchase(purchase);
              }
            } else {
              // Left pending on purpose: the store hands it back on the next
              // launch, so a purchase the server could not confirm yet (no
              // network, Google unreachable) is retried and one that was paid
              // for is never consumed without being granted.
              log('Purchase ${purchase.productID} not granted yet: $result');
            }
            break;

          case PurchaseStatus.error:
            log('Purchase error: ${purchase.error}');
            break;

          case PurchaseStatus.canceled:
            log('Purchase cancelled: ${purchase.productID}');
            break;
        }
      } catch (e, stack) {
        log('Error processing purchase: ${purchase.productID}, $e\n$stack');
      }
    }
  }

  Future<void> restorePurchase() async {
    try {
      await _iap.restorePurchases();
    } catch (error) {
      log('Error: $error');
    }
  }

  void dispose() {
    _purchasesSubscription.cancel();
  }
}
