import 'dart:async';
import 'dart:developer';

import 'package:in_app_purchase/in_app_purchase.dart';

import 'purchase_handler.dart';

class IAPService {
  IAPService._();

  static final _instance = IAPService._();

  static IAPService get instance => _instance;

  final _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _purchasesSubscription;

  IAPPurchaseHandler? _handler;

  // ✅ Cache for product metadata
  final Map<String, ProductDetails> _productDetailsMap = {};

  final Set<String> _kIds = {'credit_100', 'credit_500', 'credit_1000'};

  void configure({required IAPPurchaseHandler handler}) {
    _handler = handler;
  }

  List<ProductDetails> products = [];

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
    final response = await _iap.queryProductDetails(_kIds);
    if (response.notFoundIDs.isEmpty) {
      products = response.productDetails;
    }
  }

  Future<void> buyConsumableProduct(String productId) async {
    try {
      final response = await _iap.queryProductDetails({productId});
      if (response.notFoundIDs.isNotEmpty) {
        log('Product not found: $productId');
        return;
      }

      final product = response.productDetails.first;
      _productDetailsMap[product.id] = product;

      final purchaseParam = PurchaseParam(productDetails: product);

      await _iap.buyConsumable(
        purchaseParam: purchaseParam,
        autoConsume: true,
      );
    } catch (e) {
      log('Error buying consumable: $e');
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
            final isValid = await _verifyPurchase(purchase);
            if (isValid) {
              await _deliverProduct(purchase);
            } else {
              log('Invalid purchase detected for ${purchase.productID}');
            }

            if (purchase.pendingCompletePurchase) {
              await _iap.completePurchase(purchase);
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

  Future<void> _deliverProduct(PurchaseDetails purchase) async {
    final productId = purchase.productID;
    final product = _productDetailsMap[productId];

    if (productId.startsWith('credits_')) {
      final match = RegExp(r'^credits_(\d+)_?.*').firstMatch(productId);
      final quantity = match != null ? int.tryParse(match.group(1)!) : null;

      if (quantity != null && _handler != null && product != null) {
        final double amount = product.rawPrice;
        final String currency = product.currencyCode;

        await _handler!.grantCredits(
          quantity,
          amount: amount,
          currency: currency,
        );
      }
    } else if (productId.startsWith('subscription_')) {
      if (_handler != null) {
        await _handler!.markUserSubscribed(0);
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

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // TODO: Optionally verify purchase via backend or signature check
    return true;
  }

  void dispose() {
    _purchasesSubscription.cancel();
  }
}
