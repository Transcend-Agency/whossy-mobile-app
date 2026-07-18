import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  Future<bool> isFirstTimeOpened(String pageKey, String? uid) async {
    final asyncPrefs = SharedPreferencesAsync();

    final key = '$uid - $pageKey';

    final bool? isFirstTime = await asyncPrefs.getBool(key);

    if (isFirstTime == null) {
      await asyncPrefs.setBool(key, false);
      return true;
    }

    return false;
  }

  static const _verificationAckKey = 'verification_approved_ack';

  /// Millis of the last `face_verification.reviewed_at` the user has already
  /// seen an "approved" banner for. Used to show that banner exactly once.
  Future<int?> getVerificationApprovalAck(String? uid) async {
    final asyncPrefs = SharedPreferencesAsync();

    return asyncPrefs.getInt('$uid - $_verificationAckKey');
  }

  Future<void> setVerificationApprovalAck(String? uid, int reviewedAt) async {
    final asyncPrefs = SharedPreferencesAsync();

    await asyncPrefs.setInt('$uid - $_verificationAckKey', reviewedAt);
  }
}
