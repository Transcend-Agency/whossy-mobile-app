import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/utils/services/services.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../../../constants/index.dart';
import '../../../../../../provider/provider.dart';

class SubscribeButton extends StatelessWidget {
  final String? productId;
  final VoidCallback? onUnsubscribe;

  const SubscribeButton({super.key, this.productId, this.onUnsubscribe});

  @override
  Widget build(BuildContext context) {
    return Selector2<EditProfileNotifier, ConnectivityNotifier,
        Map<String, bool>>(
      selector: (_, edit, connection) => {
        "isPremium": edit.coreProfile?.isPremium ?? false,
        "isConnected": connection.isConnected,
        "hasPlan": edit.coreProfile?.currentPlan != null,
        "isGooglePay":
            edit.coreProfile?.paymentPlatform == PaymentPlatform.mobile,
      },
      builder: (_, values, __) {
        final isConnected = values["isConnected"]!;
        final hasPlan = values["hasPlan"]!;
        final isGooglePay = values["isGooglePay"]!;

        return Padding(
          padding: EdgeInsets.only(bottom: 14.r, left: 14.r, right: 14.r),
          child: DialogButton(
            text: _getButtonText(hasPlan, isGooglePay),
            color: AppColors.premiumContainer,
            textColor: Colors.white,
            onPressed: _getOnPressedHandler(
              context,
              productId: productId,
              isConnected: isConnected,
              hasPlan: hasPlan,
              isGooglePay: isGooglePay,
              onUnsubscribe: onUnsubscribe,
            ),
          ),
        );
      },
    );
  }

  String _getButtonText(bool hasPlan, bool isGooglePay) {
    if (!hasPlan) return "Subscribe";
    return isGooglePay ? "Cancel Plan" : "Cancel Plan via the Web App";
  }

  VoidCallback? _getOnPressedHandler(
    BuildContext context, {
    required String? productId,
    required bool isConnected,
    required bool hasPlan,
    required bool isGooglePay,
    required VoidCallback? onUnsubscribe,
  }) {
    if (productId == null) return null;

    if (!isConnected) {
      return () => showSnackbar(
            AppStrings.deviceOffline,
            context,
            snackBarType: SnackbarType.warning,
          );
    }

    if (hasPlan && !isGooglePay) {
      return null;
    }

    return () async {
      if (hasPlan && isGooglePay) {
        bool? confirm = await showConfirmationDialog(
          context,
          title: 'Stop Your Plan?',
          content: contentText(AppStrings.cancelPlan),
          yes: 'Yes, Cancel',
          no: 'No, Go Back',
        );
        if (confirm == true) onUnsubscribe?.call();
      } else {
        IAPService.instance.buySubscription(productId);
      }
    };
  }
}
