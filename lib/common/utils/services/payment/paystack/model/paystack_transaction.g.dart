// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paystack_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaystackTransaction _$PaystackTransactionFromJson(Map<String, dynamic> json) =>
    PaystackTransaction(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: TransactionData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaystackTransactionToJson(
        PaystackTransaction instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

TransactionData _$TransactionDataFromJson(Map<String, dynamic> json) =>
    TransactionData(
      id: (json['id'] as num).toInt(),
      domain: json['domain'] as String,
      status: json['status'] as String,
      reference: json['reference'] as String,
      amount: (json['amount'] as num).toInt(),
      message: json['message'] as String?,
      gatewayResponse: json['gateway_response'] as String,
      paidAt: json['paid_at'] as String,
      createdAt: json['created_at'] as String,
      channel: json['channel'] as String,
      currency: json['currency'] as String,
      ipAddress: json['ip_address'] as String,
      metadata: json['metadata'] as String,
    );

Map<String, dynamic> _$TransactionDataToJson(TransactionData instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'domain': instance.domain,
    'status': instance.status,
    'reference': instance.reference,
    'amount': instance.amount,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('message', instance.message);
  val['gateway_response'] = instance.gatewayResponse;
  val['paid_at'] = instance.paidAt;
  val['created_at'] = instance.createdAt;
  val['channel'] = instance.channel;
  val['currency'] = instance.currency;
  val['ip_address'] = instance.ipAddress;
  val['metadata'] = instance.metadata;
  return val;
}
