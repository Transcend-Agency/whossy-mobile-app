// ignore_for_file: constant_identifier_names

enum Currency {
  USD("Pay using Dollars", "\$"),
  NGN("Pay using Naira", "Ngn"),
  KES("Pay using Kenyan Shillings", "KSh");

  const Currency(this.paymentText, this.symbol);

  final String paymentText;
  final String symbol;

  static Currency? fromCode(String? code) {
    if (code == null) return null;
    return Currency.values.firstWhere(
      (e) => e.name.toUpperCase() == code.toUpperCase(),
      orElse: () => Currency.USD,
    );
  }

  String toJson() => name.toUpperCase();
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
      Currency.NGN: 500.00,
      Currency.KES: 50.00,
    },
  ),
  Credit(
    quantity: 5,
    prices: {
      Currency.USD: 9.00,
      Currency.NGN: 2000.00,
      Currency.KES: 200.00,
    },
  ),
  Credit(
    quantity: 10,
    prices: {
      Currency.USD: 15.00,
      Currency.NGN: 4000.00,
      Currency.KES: 400.00,
    },
  ),
  Credit(
    quantity: 20,
    prices: {
      Currency.USD: 25.00,
      Currency.NGN: 7000.00,
      Currency.KES: 700.00,
    },
  ),
  Credit(
    quantity: 50,
    prices: {
      Currency.USD: 50.00,
      Currency.NGN: 15000.00,
      Currency.KES: 1500.00,
    },
  ),
  Credit(
    quantity: 100,
    prices: {
      Currency.USD: 80.00,
      Currency.NGN: 25000.00,
      Currency.KES: 2000.00,
    },
  ),
];
