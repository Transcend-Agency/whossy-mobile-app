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

final credits = [
  Credit(
    quantity: 1,
  ),
  Credit(
    quantity: 5,
  ),
  Credit(
    quantity: 10,
  ),
  Credit(
    quantity: 20,
  ),
  Credit(
    quantity: 50,
  ),
  Credit(
    quantity: 100,
  ),
];
