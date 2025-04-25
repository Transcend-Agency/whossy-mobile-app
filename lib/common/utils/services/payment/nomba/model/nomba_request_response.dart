import 'package:json_annotation/json_annotation.dart';

part 'nomba_request_response.g.dart';

@JsonSerializable()
class NombaRequestResponse {
  final String code;
  final String description;
  final NombaResponseData data;

  const NombaRequestResponse({
    required this.code,
    required this.description,
    required this.data,
  });

  bool get status => code == "00"; // Success if code is "00"

  factory NombaRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$NombaRequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NombaRequestResponseToJson(this);
}

@JsonSerializable()
class NombaResponseData {
  final String checkoutLink;
  final String orderReference;

  const NombaResponseData({
    required this.checkoutLink,
    required this.orderReference,
  });

  factory NombaResponseData.fromJson(Map<String, dynamic> json) =>
      _$NombaResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$NombaResponseDataToJson(this);
}