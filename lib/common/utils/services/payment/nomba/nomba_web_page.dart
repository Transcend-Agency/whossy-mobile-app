// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../constants/index.dart';
import '../../../../components/components.dart';
import '../../../router/router.gr.dart';
import '../../../utils.dart';
import 'model/nomba_request_response.dart';
import 'service/nomba_auth_service.dart';
import 'service/nomba_payment_service.dart';

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
  late final String _callbackUrl;
  bool _hasHandledTransaction = false;

  @override
  void initState() {
    super.initState();
    _paymentService = NombaPaymentService(authService: NombaAuthService());
    _callbackUrl = _paymentService.callbackUrl;
  }

  Future<NombaRequestResponse> _makePaymentRequest() async {
    return await _paymentService.makePayment(
      email: widget.email,
      customerId: widget.customerId,
      amount: widget.amount,
      currency: widget.currency,
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
            log('Error with Nomba Payment Page: ${snapshot.error}');

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
                    final isCallbackUrl = url.contains(_callbackUrl);

                    if (!_hasHandledTransaction && isCallbackUrl) {
                      _hasHandledTransaction = true;
                      widget.transactionCompleted({"status": true});
                      Navigator.of(context).pop();
                    }
                  },
                  onWebResourceError: (error) {
                    if (_hasHandledTransaction) return;

                    _hasHandledTransaction = true;
                    final isCancel =
                        error.description.contains('ERR_NAME_NOT_RESOLVED');

                    log('WebView error: ${error.description}');
                    widget.transactionNotCompleted(
                      isCancel
                          ? TransactionErrorType.paymentCancelled
                          : TransactionErrorType.unexpectedError,
                      error.description,
                    );

                    if (isCancel) {
                      Navigator.of(context).pop();
                    }
                  },
                  onNavigationRequest: (request) {
                    final isBlocked =
                        request.url.startsWith('https://www.google.com/');
                    return isBlocked
                        ? NavigationDecision.prevent
                        : NavigationDecision.navigate;
                  },
                ),
              )
              ..loadRequest(Uri.parse(snapshot.data!.data.checkoutLink));

            // Show WebView when payment request is successful
            return WebViewWidget(controller: controller);
          }

          // Fallback UI (shouldn't happen unless data is empty)
          return const BadNetworkDialog(
            subtitle: AppStrings.errorUnknown,
          );
        },
      ),
    );
  }
}

void navigateToUSDPayment({
  required BuildContext context,
  required String email,
  required String currency,
  required double amount,
  required String customerId,
  required TransactionCompletedCallback transactionCompleted,
  required TransactionNotCompletedCallback transactionNotCompleted,
}) {
  Nav.push(
    context,
    NombaWebRoute(
      email: email,
      currency: currency,
      amount: amount,
      customerId: customerId,
      transactionCompleted: transactionCompleted,
      transactionNotCompleted: transactionNotCompleted,
    ),
  );
}
