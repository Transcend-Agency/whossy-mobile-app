// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nomba_request_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NombaRequestResponse _$NombaRequestResponseFromJson(
        Map<String, dynamic> json) =>
    NombaRequestResponse(
      code: json['code'] as String,
      description: json['description'] as String,
      data: NombaResponseData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NombaRequestResponseToJson(
        NombaRequestResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'description': instance.description,
      'data': instance.data,
    };

NombaResponseData _$NombaResponseDataFromJson(Map<String, dynamic> json) =>
    NombaResponseData(
      checkoutLink: json['checkoutLink'] as String,
      orderReference: json['orderReference'] as String,
    );

Map<String, dynamic> _$NombaResponseDataToJson(NombaResponseData instance) =>
    <String, dynamic>{
      'checkoutLink': instance.checkoutLink,
      'orderReference': instance.orderReference,
    };
