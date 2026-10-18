import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/common/utils/services/iap/purchase_verifier.dart';

void main() {
  group('verificationForErrorCode', () {
    test('a firm no from the server is a rejection', () {
      for (final code in [
        'failed-precondition',
        'permission-denied',
        'invalid-argument',
        'not-found',
      ]) {
        expect(
          verificationForErrorCode(code),
          PurchaseVerification.rejected,
          reason: code,
        );
      }
    });

    test('anything that might be temporary is retried, never rejected', () {
      for (final code in [
        'unavailable',
        'deadline-exceeded',
        'internal',
        'unauthenticated',
        'unknown',
        'resource-exhausted',
      ]) {
        expect(
          verificationForErrorCode(code),
          PurchaseVerification.retryLater,
          reason: code,
        );
      }
    });
  });

  group('shouldCompletePurchase', () {
    test('only a purchase the server granted is finished with the store', () {
      expect(shouldCompletePurchase(PurchaseVerification.granted), isTrue);
      expect(shouldCompletePurchase(PurchaseVerification.retryLater), isFalse);
      expect(shouldCompletePurchase(PurchaseVerification.rejected), isFalse);
    });
  });
}
