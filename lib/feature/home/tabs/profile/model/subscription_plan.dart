class SubscriptionPlan {
  final String discountInfo;
  final String productId;

  SubscriptionPlan({
    required this.discountInfo,
    required this.productId,
  });
}

// One monthly plan, $10, the same as the web. The 3, 6 and 12 month Play
// products stay in the console for subscribers who already hold one.
final subscriptionPlans = [
  SubscriptionPlan(
    discountInfo: "",
    productId: "subscription_1months",
  ),
];
