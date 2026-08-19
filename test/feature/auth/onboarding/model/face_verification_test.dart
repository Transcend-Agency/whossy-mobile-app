import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whossy_app/common/utils/enum/enums.dart';
import 'package:whossy_app/feature/auth/onboarding/model/face_verification.dart';

// Pure model logic — no Firebase.initializeApp()/platform channels needed
// (pre-launch plan A1: one canonical status derivation, shared with web's
// deriveVerificationStatus()).
void main() {
  group('FaceVerification.getVerificationStatus', () {
    test('never submitted (no photo, no status)', () {
      expect(FaceVerification().getVerificationStatus(),
          FaceVerificationStatus.notComplete);
    });

    test('status: pending_review -> pending', () {
      expect(
        FaceVerification(status: 'pending_review').getVerificationStatus(),
        FaceVerificationStatus.pending,
      );
    });

    test('status: approved -> complete', () {
      expect(
        FaceVerification(status: 'approved').getVerificationStatus(),
        FaceVerificationStatus.complete,
      );
    });

    test('status: rejected -> notCompleteAndDeclined', () {
      expect(
        FaceVerification(status: 'rejected').getVerificationStatus(),
        FaceVerificationStatus.notCompleteAndDeclined,
      );
    });

    test('status: revoked -> revoked', () {
      expect(
        FaceVerification(status: 'revoked').getVerificationStatus(),
        FaceVerificationStatus.revoked,
      );
    });

    test('legacy fallback: no status, no photo -> notComplete', () {
      expect(
        FaceVerification(photo: null).getVerificationStatus(),
        FaceVerificationStatus.notComplete,
      );
    });

    test('legacy fallback: no status, photo + retakePhoto true -> notCompleteAndDeclined', () {
      expect(
        FaceVerification(photo: 'https://example.com/x.jpg', retakePhoto: true)
            .getVerificationStatus(),
        FaceVerificationStatus.notCompleteAndDeclined,
      );
    });

    test('legacy fallback: no status, photo + retakePhoto false -> complete', () {
      expect(
        FaceVerification(photo: 'https://example.com/x.jpg', retakePhoto: false)
            .getVerificationStatus(),
        FaceVerificationStatus.complete,
      );
    });
  });

  group('FaceVerification.submission', () {
    test('always resets to pending_review and clears rejection_reason, snapshotting the main photo', () {
      final submission = FaceVerification.submission(
        photo: 'https://example.com/selfie.jpg',
        challengeId: 'c1',
        challengeImageUrl: 'https://example.com/pose.jpg',
        mainPhoto: 'https://example.com/main.jpg',
      );

      expect(submission.status, 'pending_review');
      expect(submission.rejectionReason, isNull);
      expect(submission.profilePhotoSnapshot, 'https://example.com/main.jpg');
      expect(submission.retakePhoto, false);
      expect(submission.getVerificationStatus(), FaceVerificationStatus.pending);
    });

    test('toJson omits reviewed_by/reviewed_at — a resubmission carries no prior verdict', () {
      final json = FaceVerification.submission(
        photo: 'https://example.com/selfie.jpg',
        mainPhoto: 'https://example.com/main.jpg',
      ).toJson();

      expect(json.containsKey('reviewed_by'), isFalse);
      expect(json.containsKey('reviewed_at'), isFalse);
      expect(json.containsKey('rejection_reason'), isFalse);
      expect(json['status'], 'pending_review');
      expect(json['profile_photo_snapshot'], 'https://example.com/main.jpg');
    });
  });

  group('FaceVerification equality', () {
    test('two submissions with the same fields are equal', () {
      final now = Timestamp.now();
      final a = FaceVerification(photo: 'p', updatedAt: now, status: 'approved');
      final b = FaceVerification(photo: 'p', updatedAt: now, status: 'approved');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('differing rejectionReason breaks equality', () {
      final a = FaceVerification(status: 'rejected', rejectionReason: 'blurry');
      final b = FaceVerification(status: 'rejected', rejectionReason: 'too dark');
      expect(a, isNot(equals(b)));
    });
  });
}
