import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../../feature/home/tabs/profile/model/subscription_plan.dart';

class InAppPurchaseService {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _purchaseSubscription;
  List<ProductDetails> _products = [];

  // Singleton pattern (optional)
  static final _instance = InAppPurchaseService._internal();
  factory InAppPurchaseService() => _instance;
  InAppPurchaseService._internal();

  /// Initializes the IAP service
  Future<void> init() async {
    final isAvailable = await _iap.isAvailable();
    if (!isAvailable) {
      debugPrint("IAP not available");
      return;
    }

    // Fetch available products
    await _loadProducts();

    // Listen to purchase updates
    _purchaseSubscription = _iap.purchaseStream.listen(_handlePurchaseUpdate);
  }

  /// Loads products from the store
  Future<void> _loadProducts() async {
    final Set<String> productIds = subscriptionPlans
        .map((plan) => plan.iapProductId) // ✅ Extract IAP product IDs
        .whereType<String>() // Remove any null values
        .toSet();

    final response = await _iap.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      debugPrint("Products not found: ${response.notFoundIDs}");
    }

    _products = response.productDetails;
  }

  /// Fetches the list of available products
  List<ProductDetails> get products => _products;

  /// Starts the purchase flow for a product
  Future<void> buyProduct(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Handles purchase updates
  void _handlePurchaseUpdate(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        _verifyPurchase(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint("Purchase error: ${purchase.error}");
      }
    }
  }

  /// Verifies and delivers the purchase
  Future<void> _verifyPurchase(PurchaseDetails purchase) async {
    // TODO: Validate purchase on backend (for subscriptions)
    debugPrint("Purchase verified: ${purchase.productID}");
  }

  /// Restores previous purchases (for subscriptions)
  Future<void> restorePurchases() async {
    await _iap.restorePurchases();
  }

  /// Dispose resources when no longer needed
  void dispose() {
    _purchaseSubscription.cancel();
  }
}
