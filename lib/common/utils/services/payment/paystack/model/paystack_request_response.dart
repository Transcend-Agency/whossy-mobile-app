import 'package:json_annotation/json_annotation.dart';

part 'paystack_request_response.g.dart';

@JsonSerializable()
class PaystackRequestResponse {
  final bool status;
  final String message;

  @JsonKey(name: 'data')
  final PaystackData data;

  const PaystackRequestResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  /// Factory constructor for deserialization
  factory PaystackRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$PaystackRequestResponseFromJson(json);

  /// Method for serialization
  Map<String, dynamic> toJson() => _$PaystackRequestResponseToJson(this);
}

@JsonSerializable()
class PaystackData {
  @JsonKey(name: 'authorization_url')
  final String authUrl;

  @JsonKey(name: 'access_code')
  final String accessCode;

  final String reference;

  const PaystackData({
    required this.authUrl,
    required this.accessCode,
    required this.reference,
  });

  /// Factory constructor for deserialization
  factory PaystackData.fromJson(Map<String, dynamic> json) =>
      _$PaystackDataFromJson(json);

  /// Method for serialization
  Map<String, dynamic> toJson() => _$PaystackDataToJson(this);
}
