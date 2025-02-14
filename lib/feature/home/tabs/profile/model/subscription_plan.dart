import 'credit.dart';

class SubscriptionPlan {
  final String duration; // e.g., "1 Month", "6 Months", "1 Year"
  final int months; // Number of months
  final Map<Currency, double> prices;
  final String discountInfo;
  final String billingCycle;

  SubscriptionPlan({
    required this.duration,
    required this.months,
    required this.prices,
    required this.discountInfo,
    required this.billingCycle,
  });

  double getPrice(Currency currency) => prices[currency] ?? 0.0;

  String getPriceFormatted(Currency currency) {
    return "${currency.symbol} ${getPrice(currency).toStringAsFixed(0)}";
  }

  // Calculate the monthly cost
  double getMonthlyCost(Currency currency) {
    return getPrice(currency) / months;
  }

  // Format monthly price
  String getMonthlyPriceFormatted(Currency currency) {
    return "${currency.symbol} ${getMonthlyCost(currency).toStringAsFixed(2)} / mo";
  }

  // Calculate savings percentage compared to 1-month plan
  double getSavingsPercentage(Currency currency) {
    double oneMonthPrice = subscriptionPlans[0].getPrice(currency);
    if (oneMonthPrice == 0.0) return 0.0; // Avoid division by zero

    double totalIfPaidMonthly = oneMonthPrice * months;
    double actualPrice = getPrice(currency);

    return ((totalIfPaidMonthly - actualPrice) / totalIfPaidMonthly) * 100;
  }

  @override
  String toString() {
    return 'SubscriptionPlan(\n'
        '  duration: $duration,\n'
        '  months: $months,\n'
        '  prices: $prices,\n'
        '  discountInfo: $discountInfo,\n'
        '  billingCycle: $billingCycle\n'
        ') \n';
  }
}

final subscriptionPlans = [
  SubscriptionPlan(
    duration: "1 Month",
    months: 1,
    prices: {
      Currency.USD: 10.00,
      Currency.NGN: 10000.00,
      Currency.KES: 1000.00,
    },
    discountInfo: "Best for trial",
    billingCycle: "Billed monthly",
  ),
  SubscriptionPlan(
    duration: "6 Months",
    months: 6,
    prices: {
      Currency.USD: 50.00,
      Currency.NGN: 50000.00,
      Currency.KES: 5000.00,
    },
    discountInfo: "Save 15%",
    billingCycle: "Billed every 6 months",
  ),
  SubscriptionPlan(
    duration: "1 Year",
    months: 12,
    prices: {
      Currency.USD: 95.00,
      Currency.NGN: 95000.00,
      Currency.KES: 9500.00,
    },
    discountInfo: "Save 25%",
    billingCycle: "Billed yearly",
  ),
];
