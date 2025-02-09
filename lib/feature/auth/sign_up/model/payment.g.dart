// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      ksh: (json['kenyan_shillings'] as num?)?.toDouble() ?? 0,
      ngn: (json['naira'] as num?)?.toDouble() ?? 0,
      usd: (json['usd'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'kenyan_shillings': instance.ksh,
      'naira': instance.ngn,
      'usd': instance.usd,
    };
