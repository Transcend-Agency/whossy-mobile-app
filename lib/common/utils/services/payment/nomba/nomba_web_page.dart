// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../constants/index.dart';
import '../../../../components/index.dart';
import '../../../index.dart';
import 'model/nomba_request_response.dart';
import 'service/nomba_auth_service.dart';
import 'service/nomba_payment_service.dart';

typedef TransactionCompletedCallback = void Function(
    Map<String, dynamic> decodedRespBody);
typedef TransactionNotCompletedCallback = void Function(
    TransactionErrorType errorType, String reason);

@RoutePage()
class NombaWebPage extends StatefulWidget {
  final String currency;
  final String email;
  final double amount;
  final String customerId;
  final TransactionCompletedCallback transactionCompleted;
  final TransactionNotCompletedCallback transactionNotCompleted;

  const NombaWebPage({
    super.key,
    required this.email,
    required this.currency,
    required this.amount,
    required this.customerId,
    required this.transactionCompleted,
    required this.transactionNotCompleted,
  });

  @override
  State<NombaWebPage> createState() => _NombaWebPageState();
}

class _NombaWebPageState extends State<NombaWebPage> {
  late final NombaPaymentService _paymentService;
  final String _callbackUrl = "https://yourcallback.com/success";

  @override
  void initState() {
    super.initState();
    _paymentService = NombaPaymentService(authService: NombaAuthService());
  }

  Future<NombaRequestResponse> _makePaymentRequest() async {
    return await _paymentService.makePayment(
      email: widget.email,
      customerId: widget.customerId,
      amount: widget.amount,
      currency: widget.currency,
      callbackUrl: _callbackUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const CustomAppBar(
        color: Colors.white,
        title: 'Payment',
      ),
      body: FutureBuilder<NombaRequestResponse>(
        future: _makePaymentRequest(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator while waiting for response
            return const Center(
              child: AppLoader(color: AppColors.primaryColor, size: 24),
            );
          }

          if (snapshot.hasError) {
            log('Error: ${snapshot.error}');
            return Center(
              child: Text('Error: ${snapshot.error}'),
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
                      widget.transactionCompleted({"status": "success"});
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
                    if (request.url.startsWith('https://www.google.com/')) {
                      return NavigationDecision.prevent;
                    }
                    return NavigationDecision.navigate;
                  },
                ),
              )
              ..loadRequest(Uri.parse(snapshot.data!.data.checkoutLink));

            // Show WebView when payment request is successful
            return WebViewWidget(controller: controller);
          }

          // Fallback UI (shouldn't happen unless data is empty)
          return const Center(
            child: Text('Unexpected error occurred'),
          );
        },
      ),
    );
  }
}
