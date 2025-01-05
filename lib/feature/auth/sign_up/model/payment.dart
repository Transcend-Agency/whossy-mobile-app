import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  @JsonKey(name: 'kenyan_shillings')
  double ksh;

  @JsonKey(name: 'naira')
  double ngn;

  Payment({
    this.ksh = 0,
    this.ngn = 0,
  });

  /// Factory method for JSON serialization.
  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  /// Method for JSON deserialization.
  Map<String, dynamic> toJson() => _$PaymentToJson(this);

  /// Update method to increment or set values.
  void updatePayment({
    double? kshIncrement,
    double? kshOverride,
    double? ngnIncrement,
    double? ngnOverride,
  }) {
    if (kshOverride != null) {
      ksh = kshOverride; // Direct override
    } else if (kshIncrement != null) {
      ksh += kshIncrement; // Increment by the specified amount
    }

    if (ngnOverride != null) {
      ngn = ngnOverride; // Direct override
    } else if (ngnIncrement != null) {
      ngn += ngnIncrement; // Increment by the specified amount
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Payment && other.ksh == ksh && other.ngn == ngn;
  }

  @override
  int get hashCode {
    return Object.hash(ksh, ngn);
  }

  @override
  String toString() {
    return 'Payment(ksh: $ksh, ngn: $ngn)';
  }
}
