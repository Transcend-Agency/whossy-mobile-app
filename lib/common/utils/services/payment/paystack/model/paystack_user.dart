import 'package:json_annotation/json_annotation.dart';

import '../../../../../../feature/home/tabs/profile/model/credit.dart';
import '../../../../app_utils.dart';

part 'paystack_user.g.dart';

@JsonSerializable()
class PaystackUser {
  @JsonKey(name: 'customer_id')
  int? customerId;

  @JsonKey(
    fromJson: AppUtils.currencyFromJson,
    toJson: AppUtils.currencyToJson,
  )
  Currency? currency;

  PaystackUser({
    this.customerId,
    this.currency,
  });

  factory PaystackUser.fromJson(Map<String, dynamic> json) =>
      _$PaystackUserFromJson(json);

  Map<String, dynamic> toJson() => _$PaystackUserToJson(this);

  static PaystackUser? paystackUserFromJson(Map<String, dynamic>? json) {
    if (json == null) return PaystackUser();
    return PaystackUser.fromJson(json);
  }

  static Map<String, dynamic>? paystackUserToJson(PaystackUser? user) {
    return user?.toJson();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaystackUser &&
          runtimeType == other.runtimeType &&
          customerId == other.customerId &&
          currency == other.currency;

  @override
  int get hashCode => Object.hash(customerId, currency);

  @override
  String toString() {
    return 'PaystackUser(\n'
        '     customerId: $customerId,\n'
        '     currency: ${currency?.name}\n'
        ' )';
  }
}
