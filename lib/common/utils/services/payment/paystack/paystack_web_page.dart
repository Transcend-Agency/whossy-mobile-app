import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:whossy_app/feature/home/tabs/profile/model/credit.dart';

import '../../../../../constants/index.dart';
import '../../../../components/components.dart';
import '../../../router/router.gr.dart';
import '../../../utils.dart';
import 'model/paystack_request_response.dart';
import 'model/paystack_user.dart';
import 'service/paystack_payment_service.dart';

@RoutePage()
class PaystackWebPage extends StatefulWidget {
  final String currency;
  final String email;
  final double amount;
  final String? plan;
  final TransactionCompletedCallback transactionCompleted;
  final TransactionNotCompletedCallback transactionNotCompleted;

  const PaystackWebPage({
    super.key,
    required this.email,
    required this.currency,
    required this.amount,
    required this.transactionCompleted,
    required this.transactionNotCompleted,
    this.plan,
  });

  @override
  State<PaystackWebPage> createState() => _PaystackWebPageState();
}

class _PaystackWebPageState extends State<PaystackWebPage> {
  late final PaystackPaymentService _paymentService;
  late final String _callbackUrl;

  @override
  void initState() {
    super.initState();
    _paymentService = PaystackPaymentService(widget.currency);
    _callbackUrl = _paymentService.callbackUrl;
  }

  Future<PaystackRequestResponse?> _initializePayment() async {
    try {
      return await _paymentService.makePayment(
        email: widget.email,
        amount: widget.amount,
        currency: widget.currency,
        plan: widget.plan,
      );
    } on TransactionErrorType catch (e) {
      widget.transactionNotCompleted(
        e,
        "Payment initialization failed",
      );

      return null;
    }
  }

  Future<Map<String, dynamic>> _checkTransaction(String reference) async {
    try {
      final transaction = await _paymentService.verifyTransaction(reference);

      if (transaction.status == true && transaction.data.status == "success") {
        final paystackUser = PaystackUser(
          customerId: transaction.data.customer.id,
          currency: Currency.fromCode(transaction.data.currency),
        );

        return {
          "status": true,
          "paystack_user": paystackUser.toJson(),
        };
      } else {
        return {
          "status": false,
          "message": "Transaction verification failed",
        };
      }
    } catch (e) {
      log("Transaction verification failed: $e");
      return {
        "status": false,
        "message": e.toString(),
      };
    }
  }

  void _handleTransactionCompletion(String reference) async {
    final transactionResult = await _checkTransaction(reference);

    if (transactionResult['status'] == true) {
      widget.transactionCompleted({
        "status": true,
        "paystack_user": transactionResult['paystack_user']
      });
    } else {
      widget.transactionNotCompleted(
        TransactionErrorType.unexpectedError,
        transactionResult['message'] ?? "Transaction verification failed",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const CustomAppBar(
        color: Colors.white,
        title: 'Payment',
      ),
      body: FutureBuilder<PaystackRequestResponse?>(
        future: _initializePayment(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: AppLoader(color: AppColors.primaryColor, size: 24),
            );
          }

          if (snapshot.hasError) {
            log('Error with Paystack Payment Page: ${snapshot.error}');

            return const BadNetworkDialog(
              subtitle: AppStrings.deviceOffline,
            );
          }

          if (snapshot.hasData && snapshot.data!.status == true) {
            final controller = WebViewController()
              ..setJavaScriptMode(JavaScriptMode.unrestricted)
              ..setNavigationDelegate(
                NavigationDelegate(
                  onProgress: (progress) {},
                  onPageFinished: (String url) {
                    if (url.contains(_callbackUrl)) {
                      widget.transactionCompleted({
                        "status": true,
                        "data": {"status": "success"}
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  onWebResourceError: (WebResourceError error) {
                    log('WebView error: ${error.description}');
                    widget.transactionNotCompleted(
                      TransactionErrorType.unexpectedError,
                      error.description,
                    );
                  },
                  onNavigationRequest: (NavigationRequest request) {
                    final url = request.url;

                    // Define important URLs to check
                    final importantUrls = {
                      _callbackUrl,
                      'https://paystack.co/close',
                      'https://standard.paystack.co/close'
                    };

                    // If the URL matches any of these, handle it
                    if (importantUrls.any(url.contains)) {
                      _handleTransactionCompletion(
                        snapshot.data!.data.reference,
                      );

                      if (context.mounted) Navigator.of(context).pop();

                      return NavigationDecision.prevent;
                    }

                    return NavigationDecision.navigate;
                  },
                ),
              )
              ..loadRequest(Uri.parse(snapshot.data!.data.authUrl));

            return WebViewWidget(controller: controller);
          }

          return const BadNetworkDialog(
            subtitle: AppStrings.errorUnknown,
          );
        },
      ),
    );
  }
}

void navigateToPaystackPayment({
  required BuildContext context,
  required String email,
  required String currency,
  required double amount,
  required TransactionCompletedCallback transactionCompleted,
  required TransactionNotCompletedCallback transactionNotCompleted,
  String? plan,
}) {
  Nav.push(
    context,
    PaystackWebRoute(
      email: email,
      currency: currency,
      amount: amount,
      transactionCompleted: transactionCompleted,
      transactionNotCompleted: transactionNotCompleted,
      plan: plan,
    ),
  );
}
