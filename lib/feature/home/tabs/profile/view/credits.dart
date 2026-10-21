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
    final products = useState(IAPService.instance.creditProducts);
    final isLoading = useState(false);

    Future<void> reload() async {
      isLoading.value = true;
      try {
        await IAPService.instance.updateAvailableProducts();
      } catch (_) {}
      products.value = IAPService.instance.creditProducts;
      isLoading.value = false;
    }

    // Products load once at launch; ask the store again when the screen opens
    // in case that came back empty or late.
    useEffect(() {
      reload();
      return null;
    }, const []);

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
                    addHeight(8),
                    Selector<EditProfileNotifier, (int, int)>(
                      selector: (_, edit) => (
                        edit.coreProfile?.creditBalance ?? 0,
                        edit.coreProfile?.creditsOnHold ?? 0,
                      ),
                      builder: (_, balances, __) {
                        final (balance, held) = balances;
                        return Text(
                          held > 0
                              ? 'Balance: $balance · $held on hold'
                              : 'Balance: $balance',
                          textAlign: TextAlign.center,
                          style: TextStyles.profileHead.copyWith(
                            fontSize: AppUtils.scale(12.sp) ?? 15.sp,
                            color: Colors.black87,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            addHeight(20),
            Expanded(
              child: products.value.isEmpty
                  ? Center(
                      child: isLoading.value
                          ? const CircularProgressIndicator()
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Credit packs are not available right now.\n'
                                  '${IAPService.instance.productLoadIssue ?? 'Check your connection and try again.'}',
                                  textAlign: TextAlign.center,
                                  style: TextStyles.hintThemeText,
                                ),
                                addHeight(12),
                                TextButton(
                                  onPressed: reload,
                                  child: const Text('Try again'),
                                ),
                              ],
                            ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: products.value.map((product) {
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
                                  formatPrice(
                                      product.rawPrice, product.currencyCode),
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
            PayButton(
              productId: selectedProductId.value,
              hasProducts: products.value.isNotEmpty,
            ),
          ],
        ),
      ),
    );
  }
}

class PayButton extends StatelessWidget {
  final String? productId;
  final bool hasProducts;

  const PayButton({super.key, this.productId, this.hasProducts = true});

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
                ? () => showSnackbar(
                      hasProducts
                          ? 'Select a credit pack first.'
                          : 'Credit packs are not available right now.',
                      context,
                    )
                : isConnected
                    ? () async {
                        final started = await IAPService.instance
                            .buyConsumableProduct(productId!);
                        if (!started && context.mounted) {
                          showSnackbar(
                            'Could not start the purchase. Try again.',
                            context,
                          );
                        }
                      }
                    : () => showSnackbar(AppStrings.deviceOffline, context),
          ),
        );
      },
    );
  }
}
