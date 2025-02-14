// ignore_for_file: constant_identifier_names

enum Currency {
  USD("Pay using Dollars", "\$"),
  NGN("Pay using Naira", "Ngn"),
  KES("Pay using Kenyan Shillings", "KSh");

  const Currency(this.paymentText, this.symbol);

  final String paymentText;
  final String symbol;
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
    quantity: 1,
    prices: {
      Currency.USD: 2.00,
      Currency.NGN: 1000.00,
      Currency.KES: 100.00,
    },
  ),
  Credit(
    quantity: 5,
    prices: {
      Currency.USD: 9.00,
      Currency.NGN: 4500.00,
      Currency.KES: 450.00,
    },
  ),
  Credit(
    quantity: 10,
    prices: {
      Currency.USD: 17.00,
      Currency.NGN: 8500.00,
      Currency.KES: 850.00,
    },
  ),
  Credit(
    quantity: 20,
    prices: {
      Currency.USD: 33.00,
      Currency.NGN: 16500.00,
      Currency.KES: 1650.00,
    },
  ),
  Credit(
    quantity: 100,
    prices: {
      Currency.USD: 150.00,
      Currency.NGN: 80000.00,
      Currency.KES: 8000.00,
    },
  ),
];
