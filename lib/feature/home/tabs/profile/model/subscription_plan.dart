class SubscriptionPlan {
  final String discountInfo;
  final String productId;

  SubscriptionPlan({
    required this.discountInfo,
    required this.productId,
  });
}

final subscriptionPlans = [
  SubscriptionPlan(
    discountInfo: "Best for trial",
    productId: "subscription_1months",
  ),
  SubscriptionPlan(
    discountInfo: "Save 15%",
    productId: "subscription_3months_usd",
  ),
  SubscriptionPlan(
    discountInfo: "Save 15%",
    productId: "subscription_6months_usd",
  ),
  SubscriptionPlan(
    discountInfo: "Save 25%",
    productId: "subscription_1year_usd",
  ),
];
