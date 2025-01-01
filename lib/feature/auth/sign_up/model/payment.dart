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

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);

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
