import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/feature/auth/sign_up/model/user_status.dart';

// Pure model logic — no Firebase.initializeApp()/platform channels needed
// (pre-launch plan C1: `online` alone isn't trustworthy since onDisconnect
// can lag or never fire, so "recently online" also requires a fresh
// lastSeen). Takes `currentTime` explicitly, same convention as the
// pre-existing `getLastSeen(Timestamp currentTime)`, so tests don't need to
// mock the clock.
void main() {
  group('UserStatus.isRecentlyOnline', () {
    final now = Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(1700000000000));

    test('true when online and lastSeen is within the recency window', () {
      final status = UserStatus(
        online: true,
        lastSeen: Timestamp.fromDate(now.toDate().subtract(const Duration(seconds: 1))),
      );
      expect(status.isRecentlyOnline(now), true);
    });

    test('false when online but lastSeen predates the recency window (missed disconnect)', () {
      final status = UserStatus(
        online: true,
        lastSeen: Timestamp.fromDate(
          now.toDate().subtract(UserStatus.recencyWindow + const Duration(seconds: 1)),
        ),
      );
      expect(status.isRecentlyOnline(now), false);
    });

    test('false when offline even with a recent lastSeen', () {
      final status = UserStatus(
        online: false,
        lastSeen: Timestamp.fromDate(now.toDate().subtract(const Duration(seconds: 1))),
      );
      expect(status.isRecentlyOnline(now), false);
    });

    test('false when lastSeen is missing', () {
      final status = UserStatus(online: true);
      expect(status.isRecentlyOnline(now), false);
    });
  });
}
