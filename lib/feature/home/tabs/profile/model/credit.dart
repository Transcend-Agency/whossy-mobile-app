enum Credit {
  fifty(quantity: 50, price: 12.99),
  hundred(quantity: 100, price: 12.99),
  twoHundred(quantity: 200, price: 12.99),
  thousand(quantity: 1000, price: 12.99);

  const Credit({required this.quantity, required this.price});

  final int quantity;
  final double price;
}
