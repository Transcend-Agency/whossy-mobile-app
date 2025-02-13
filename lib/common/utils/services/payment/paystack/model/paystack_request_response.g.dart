// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paystack_request_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaystackRequestResponse _$PaystackRequestResponseFromJson(
        Map<String, dynamic> json) =>
    PaystackRequestResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: PaystackData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaystackRequestResponseToJson(
        PaystackRequestResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

PaystackData _$PaystackDataFromJson(Map<String, dynamic> json) => PaystackData(
      authUrl: json['authorization_url'] as String,
      accessCode: json['access_code'] as String,
      reference: json['reference'] as String,
    );

Map<String, dynamic> _$PaystackDataToJson(PaystackData instance) =>
    <String, dynamic>{
      'authorization_url': instance.authUrl,
      'access_code': instance.accessCode,
      'reference': instance.reference,
    };
