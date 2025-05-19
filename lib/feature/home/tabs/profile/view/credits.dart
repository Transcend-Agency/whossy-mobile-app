import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../common/components/components.dart';
import '../../../../../common/styles/text_style.dart';
import '../../../../../common/utils/services/services.dart';
import '../../../../../common/utils/utils.dart';
import '../../../../../constants/index.dart';
import '../../../../../provider/provider.dart';

@RoutePage()
class Credits extends HookWidget {
  const Credits({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedProductId = useState<String?>(null);

    return AppScaffold(
      appBar: CustomAppBar(
        addBarHeight: 4,
        title: 'Whossy Credits',
        color: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 14.r, right: 14.r, top: 16.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.yellowContainer,
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.all(14.r),
              child: Center(
                child: Column(
                  children: [
                    SizedBox.square(
                      dimension: 80.r,
                      child: Image.asset(
                        AppAssets.credit2,
                      ),
                    ),
                    addHeight(6),
                    Text(
                      'Whossy Credits',
                      textAlign: TextAlign.center,
                      style: TextStyles.title.copyWith(
                        fontSize: AppUtils.scale(32) ?? 26,
                      ),
                    ),
                    addHeight(8),
                    Opacity(
                      opacity: 0.9,
                      child: Text(
                        "Unlock conversations with Whossy credits!",
                        textAlign: TextAlign.center,
                        style: TextStyles.hintThemeText.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: AppUtils.scale(10.sp) ?? 13.5.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            addHeight(20),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: IAPService.instance.creditProducts.map((product) {
                    return GenericTile(
                      unselectedBorderColor: AppColors.outlinedColor,
                      tileColor: Colors.white,
                      bottom: 14.r,
                      value: product.id,
                      groupValue: selectedProductId.value,
                      onChanged: (id) => selectedProductId.value = id,
                      title: '${product.id.creditQty} Credits',
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          addHeight(3),
                          Text(
                            formatPrice(product.rawPrice, product.currencyCode),
                            style: TextStyles.profileHead.copyWith(
                              fontSize: AppUtils.scale(12.sp) ?? 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            PayButton(productId: selectedProductId.value),
          ],
        ),
      ),
    );
  }
}

class PayButton extends StatelessWidget {
  final String? productId;

  const PayButton({super.key, this.productId});

  @override
  Widget build(BuildContext context) {
    return Selector<ConnectivityNotifier, bool>(
      selector: (_, connection) => connection.isConnected,
      builder: (_, isConnected, __) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: DialogButton(
            text: "Continue",
            color: AppColors.buttonColor,
            textColor: Colors.white,
            onPressed: productId == null
                ? null
                : isConnected
                    ? () async => await IAPService.instance
                        .buyConsumableProduct(productId!)
                    : () => showSnackbar(AppStrings.deviceOffline, context),
          ),
        );
      },
    );
  }
}
