import 'dart:developer';

import 'package:cloud_functions/cloud_functions.dart';

/// What the server decided about a Play purchase.
enum PurchaseVerification {
  /// Google confirmed it and the server granted the credits or premium (or
  /// had already granted this same purchase).
  granted,

  /// The server could not decide right now (no network, Google unreachable,
  /// not signed in). The purchase must stay pending so it is retried.
  retryLater,

  /// The server decided this is not a purchase it will honour.
  rejected,
}

/// Maps a Cloud Functions error code to what the app should do with the
/// purchase. Only a firm "no" is [PurchaseVerification.rejected]; anything
/// that might be temporary is retried, so a customer who really paid is never
/// left without what they bought.
PurchaseVerification verificationForErrorCode(String code) {
  switch (code) {
    case 'failed-precondition':
    case 'permission-denied':
    case 'invalid-argument':
    case 'not-found':
      return PurchaseVerification.rejected;
    default:
      return PurchaseVerification.retryLater;
  }
}

/// Whether the purchase should be finished with the store (which consumes a
/// credit pack and acknowledges a subscription). Only after the server has
/// granted it: finishing earlier would use up the purchase with nothing given.
bool shouldCompletePurchase(PurchaseVerification result) =>
    result == PurchaseVerification.granted;

abstract class PurchaseVerifier {
  Future<PurchaseVerification> verify({
    required String productId,
    required String purchaseToken,
  });
}

/// Asks the `verifyPlayPurchase` Cloud Function. The server checks the token
/// with Google and works out what the purchase is worth; the app only says
/// which product and which token.
class FunctionsPurchaseVerifier implements PurchaseVerifier {
  @override
  Future<PurchaseVerification> verify({
    required String productId,
    required String purchaseToken,
  }) async {
    try {
      await FirebaseFunctions.instance.httpsCallable('verifyPlayPurchase').call(
        {'productId': productId, 'purchaseToken': purchaseToken},
      );
      return PurchaseVerification.granted;
    } on FirebaseFunctionsException catch (e) {
      log('verifyPlayPurchase refused: ${e.code} ${e.message}');
      return verificationForErrorCode(e.code);
    } catch (e) {
      log('verifyPlayPurchase failed: $e');
      return PurchaseVerification.retryLater;
    }
  }
}
