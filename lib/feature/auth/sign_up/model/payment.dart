import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  @JsonKey(name: 'kenyan_shillings')
  double ksh;

  @JsonKey(name: 'naira')
  double ngn;

  @JsonKey(name: 'usd')
  double usd;

  Payment({
    this.ksh = 0,
    this.ngn = 0,
    this.usd = 0,
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
    double? usdIncrement,
    double? usdOverride,
  }) {
    if (kshOverride != null) {
      ksh = kshOverride;
    } else if (kshIncrement != null) {
      ksh += kshIncrement;
    }

    if (ngnOverride != null) {
      ngn = ngnOverride;
    } else if (ngnIncrement != null) {
      ngn += ngnIncrement;
    }

    if (usdOverride != null) {
      usd = usdOverride;
    } else if (usdIncrement != null) {
      usd += usdIncrement;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Payment &&
        other.ksh == ksh &&
        other.ngn == ngn &&
        other.usd == usd;
  }

  @override
  int get hashCode {
    return Object.hash(ksh, ngn, usd);
  }

  @override
  String toString() {
    return 'Payment(ksh: $ksh, ngn: $ngn, usd: $usd)';
  }
}
