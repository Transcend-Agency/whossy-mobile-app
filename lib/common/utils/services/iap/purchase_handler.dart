import 'package:whossy_app/feature/home/edit_profile/data/state/edit_profile_notifier.dart';

abstract class IAPPurchaseHandler {
  Future<void> grantCredits(
    int quantity, {
    required double amount,
    required String currency,
  });
  Future<void> markUserSubscribed({
    required String planId,
    required String purchaseToken,
  });
}

class AppPurchaseHandler implements IAPPurchaseHandler {
  final EditProfileNotifier editProfile;

  AppPurchaseHandler(this.editProfile);

  @override
  Future<void> grantCredits(
    int quantity, {
    required double amount,
    required String currency,
  }) async {
    await editProfile.addCreditsAfterPurchase(
      credits: quantity,
      amount: amount,
      currency: currency,
    );
  }

  @override
  Future<void> markUserSubscribed(
      {required String planId, required String purchaseToken}) async {
    await editProfile.updateSubscription(
      planId: planId,
      purchaseToken: purchaseToken,
    );
  }
}
