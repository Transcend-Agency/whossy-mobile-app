import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../../../../env.dart';
import '../../../../index.dart';
import '../model/paystack_request_response.dart';
import '../model/paystack_transaction.dart';

class PaystackPaymentService {
  final String secretKey;
  final String callbackUrl;

  PaystackPaymentService(String currency)
      : secretKey = _getSecretKey(currency),
        callbackUrl = Env.paymentCallbackUrl;

  static String _getSecretKey(String currency) {
    switch (currency) {
      case "NGN":
        return Env.paystackSecretKeyNgn;
      case "KES":
        return Env.paystackSecretKeyKes;
      default:
        return '';
    }
  }

  Future<PaystackRequestResponse> makePayment({
    required String email,
    required double amount,
    required String currency,
    String? plan,
  }) async {
    try {
      final requestBody = {
        "email": email,
        "amount": (amount * 100).toStringAsFixed(0),
        "reference": const Uuid().v4(),
        "currency": currency,
        "plan": plan,
        "callback_url": callbackUrl,
      };

      final url = Uri.parse('https://api.paystack.co/transaction/initialize');

      final response = await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $secretKey',
            },
            body: jsonEncode(requestBody),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw TimeoutException("Request timed out."),
          );

      if (response.statusCode == 200) {
        return PaystackRequestResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Payment initialization failed: ${response.body}");
      }
    } on TimeoutException {
      log("Payment request timed out.");
      throw TransactionErrorType.paymentTimeout;
    } on Exception catch (e) {
      log("Payment error: $e");

      if (e is SocketException || e is HttpException) {
        throw TransactionErrorType.noInternetConnection;
      }

      throw TransactionErrorType.unexpectedError;
    }
  }

  Future<PaystackTransaction> verifyTransaction(String reference) async {
    try {
      final url =
          Uri.parse('https://api.paystack.co/transaction/verify/$reference');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $secretKey',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw TimeoutException("Request timed out."),
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['status'] == true) {
          return PaystackTransaction.fromJson(responseData);
        } else {
          throw Exception(
              "Transaction verification failed: ${responseData['message']}");
        }
      } else {
        throw Exception("Transaction verification failed: ${response.body}");
      }
    } on TimeoutException {
      log("Transaction verification request timed out.");
      throw TransactionErrorType.paymentTimeout;
    } on Exception catch (e) {
      log("Verify transaction error: $e");

      if (e is SocketException || e is HttpException) {
        throw TransactionErrorType.noInternetConnection;
      }

      throw TransactionErrorType.unexpectedError;
    }
  }
}
