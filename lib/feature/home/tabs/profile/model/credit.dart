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
  final String productId;

  Credit({
    required this.quantity,
  }) : productId = 'credits_${quantity}_usd';
}

// Matches the web prices: 5 for $1, 10 for $2, 50 for $10, 100 for $20,
// 200 for $30, 1000 for $40. The Play product price must be set to match.
final credits = [
  Credit(quantity: 5),
  Credit(quantity: 10),
  Credit(quantity: 50),
  Credit(quantity: 100),
  Credit(quantity: 200),
  Credit(quantity: 1000),
];
