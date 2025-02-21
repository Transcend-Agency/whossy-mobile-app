import 'package:intl/intl.dart';

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
    final price = getPrice(currency);
    final formatter = NumberFormat('#,###');

    return "${currency.symbol} ${formatter.format(price)}";
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
    duration: "Monthly",
    months: 1,
    prices: {
      Currency.USD: 10.00,
      Currency.NGN: 2000.00,
      Currency.KES: 800.00,
    },
    discountInfo: "Best for trial",
    billingCycle: "Billed monthly",
  ),
  SubscriptionPlan(
    duration: "3 Months",
    months: 3,
    prices: {
      Currency.USD: 25.00,
      Currency.NGN: 5000.00,
      Currency.KES: 2000.00,
    },
    discountInfo: "Save 15%",
    billingCycle: "Billed every 3 months",
  ),
  SubscriptionPlan(
    duration: "6 Months",
    months: 6,
    prices: {
      Currency.USD: 45.00,
      Currency.NGN: 8000.00,
      Currency.KES: 3500.00,
    },
    discountInfo: "Save 15%",
    billingCycle: "Billed every 6 months",
  ),
  SubscriptionPlan(
    duration: "1 Year",
    months: 12,
    prices: {
      Currency.USD: 80.00,
      Currency.NGN: 15000.00,
      Currency.KES: 6000.00,
    },
    discountInfo: "Save 25%",
    billingCycle: "Billed yearly",
  ),
];
