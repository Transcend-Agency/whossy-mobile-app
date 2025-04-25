import 'package:json_annotation/json_annotation.dart';

part 'paystack_transaction.g.dart';

@JsonSerializable()
class PaystackTransaction {
  final bool status;
  final String message;
  final TransactionData data;

  PaystackTransaction({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PaystackTransaction.fromJson(Map<String, dynamic> json) =>
      _$PaystackTransactionFromJson(json);
  Map<String, dynamic> toJson() => _$PaystackTransactionToJson(this);
}

@JsonSerializable()
class TransactionData {
  final int id;
  final String domain;
  final String status;
  final String reference;
  final int amount;
  final String? message;
  @JsonKey(name: 'gateway_response')
  final String gatewayResponse;
  @JsonKey(name: 'paid_at')
  final String paidAt;
  @JsonKey(name: 'created_at')
  final String createdAt;
  final String channel;
  final String currency;
  @JsonKey(name: 'ip_address')
  final String ipAddress;
  final String metadata;

  TransactionData({
    required this.id,
    required this.domain,
    required this.status,
    required this.reference,
    required this.amount,
    this.message,
    required this.gatewayResponse,
    required this.paidAt,
    required this.createdAt,
    required this.channel,
    required this.currency,
    required this.ipAddress,
    required this.metadata,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      _$TransactionDataFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionDataToJson(this);
}