import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../../../../env.dart';
import '../model/nomba_request_response.dart';
import 'nomba_auth_service.dart';

class NombaPaymentService {
  final NombaAuthService authService;
  final String accountId;

  NombaPaymentService({required this.authService})
      : accountId = Env.nombaAccountId;

  Future<NombaRequestResponse> makePayment({
    required String email,
    required String customerId,
    required double amount,
    required String currency,
    required String callbackUrl,
  }) async {
    try {
      final token = await authService.getAccessToken();

      final requestBody = {
        "order": {
          "customerEmail": email,
          "amount": amount.round(),
          "orderReference": const Uuid().v4(),
          "currency": currency,
          "callbackUrl": callbackUrl,
        }
      };

      final url = Uri.parse('https://api.nomba.com/v1/checkout/order');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
              'accountId': accountId,
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException("Request timed out."),
          );

      if (response.statusCode == 200) {
        return NombaRequestResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorMessage = _handleErrorResponse(response);
        throw Exception("Payment failed: $errorMessage");
      }
    } on TimeoutException {
      log("Payment request timed out.");
      throw Exception("Payment request timeout.");
    } catch (e) {
      log("Payment error: $e");
      throw Exception("Payment request failed: ${e.toString()}");
    }
  }

  /// Handles various HTTP error responses from Nomba API.
  String _handleErrorResponse(http.Response response) {
    try {
      final Map<String, dynamic> errorData = jsonDecode(response.body);
      return errorData['description'] ?? "Unknown error occurred.";
    } catch (_) {
      return "Failed to parse error response.";
    }
  }
}
