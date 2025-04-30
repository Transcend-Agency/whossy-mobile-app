import 'package:intl/intl.dart';

import '../../../../../env.dart';
import 'credit.dart';

class SubscriptionPlan {
  final String duration; // e.g., "1 Month", "6 Months", "1 Year"
  final int months; // Number of months
  final Map<Currency, double> prices;
  final String discountInfo;
  final String billingCycle;
  final Map<Currency, String> planCodes; // New field for Paystack plan codes

  SubscriptionPlan({
    required this.duration,
    required this.months,
    required this.prices,
    required this.discountInfo,
    required this.billingCycle,
    required this.planCodes,
  });

  double getPrice(Currency currency) => prices[currency] ?? 0.0;

  String getPriceFormatted(Currency currency) {
    final price = getPrice(currency);
    final formatter = NumberFormat('#,###');

    return "${currency.symbol} ${formatter.format(price)}";
  }

  double getMonthlyBillingAmount(Currency currency) {
    final totalPrice = getPrice(currency);
    return months > 0 ? totalPrice / months : 0.0;
  }

  String getMonthlyRate(Currency currency) {
    double amount = getMonthlyBillingAmount(currency);
    final formatter = NumberFormat('#,###.##');

    String formattedAmount = formatter.format(amount);

    return '${currency.symbol} $formattedAmount / mo';
  }

  // Get the Paystack plan code for the given currency
  String? getPlanCode(Currency currency) => planCodes[currency];

  @override
  String toString() {
    return 'SubscriptionPlan(\n'
        '  duration: $duration,\n'
        '  months: $months,\n'
        '  prices: $prices,\n'
        '  discountInfo: $discountInfo,\n'
        '  billingCycle: $billingCycle,\n'
        '  planCodes: $planCodes\n'
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
    planCodes: {
      Currency.NGN: Env.paystackPlanCodeNgnMonthly,
    },
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
    billingCycle: "billed quarterly",
    planCodes: {
      Currency.NGN: Env.paystackPlanCodeNgn3Months,
    },
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
    billingCycle: "billed biannually",
    planCodes: {
      Currency.NGN: Env.paystackPlanCodeNgn6Months,
    },
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
    billingCycle: "billed annually",
    planCodes: {
      Currency.NGN: Env.paystackPlanCodeNgnYearly,
    },
  ),
];
