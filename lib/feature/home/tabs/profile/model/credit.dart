// ignore_for_file: constant_identifier_names
enum Currency {
  USD("Pay using Dollars"),
  NGN("Pay using Naira"),
  KES("Pay using Kenyan Shillings");

  const Currency(this.paymentText);

  final String paymentText;
}

class Credit {
  final int quantity;
  final Map<Currency, double> prices;

  Credit({
    required this.quantity,
    required this.prices,
  });

  double getPrice(Currency currency) {
    return prices[currency] ?? 0.0;
  }
}

final credits = [
  Credit(
    quantity: 5,
    prices: {
      Currency.USD: 9.99,
      Currency.NGN: 9500.00,
      Currency.KES: 1650.00,
    },
  ),
  Credit(
    quantity: 10,
    prices: {
      Currency.USD: 19.99,
      Currency.NGN: 18500.00,
      Currency.KES: 3250.00,
    },
  ),
  Credit(
    quantity: 20,
    prices: {
      Currency.USD: 39.99,
      Currency.NGN: 36000.00,
      Currency.KES: 6500.00,
    },
  ),
  Credit(
    quantity: 50,
    prices: {
      Currency.USD: 99.99,
      Currency.NGN: 165000.00,
      Currency.KES: 28500.00,
    },
  ),
];
