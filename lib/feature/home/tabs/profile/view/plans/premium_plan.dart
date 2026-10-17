import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../common/components/components.dart';
import '../../../../../../common/utils/services/services.dart';
import '../../../../../../common/utils/utils.dart';
import '../../../../../../provider/provider.dart';
import '../../../../edit_profile/model/core_profile.dart';
import '../../data/source/subscription_plan_data.dart';
import '../widgets/_.dart';
import '../widgets/sub_container.dart';
import '../widgets/subscribe_button.dart';

class PremiumPlan extends HookWidget {
  const PremiumPlan({super.key});

  @override
  Widget build(BuildContext context) {
    final plans = IAPService.instance.subscriptionProducts;
    final planId = useState<String?>(null);

    final profile = useMemoized(
      () => useContext().read<EditProfileNotifier>().coreProfile,
    );

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if ((profile?.isPremium ?? false) && profile?.currentPlan != null) {
          planId.value = profile!.currentPlan!;
        }
      });
      return null;
    }, []);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        addHeight(4),
        Selector<EditProfileNotifier, CoreProfile?>(
          selector: (_, edit) => edit.staticProfile,
          builder: (_, profileData, __) {
            bool hasActivePlan = (profileData?.isPremium ?? false) &&
                (profileData?.currentPlan != null);

            Iterable<ProductDetails> displayedPlans = hasActivePlan
                ? plans.where((p) => p.id == profileData!.currentPlan!).toList()
                : plans;

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AppAnimatedSwitcher(
                child: Row(
                  key: ValueKey(hasActivePlan),
                  children: [
                    addWidth(14),
                    ...displayedPlans.map((product) {
                      return Padding(
                        padding: EdgeInsets.only(right: 12.r),
                        child: SubscriptionBilling(
                          value: product.id,
                          groupValue: planId.value,
                          product: product,
                          onChanged: (id) => planId.value = id,
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.r),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: premiumPlanData.map((sub) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6.h),
                    child: SubscriptionContainer(
                      title: sub.title,
                      feature: sub.feature,
                      chipText: sub.type,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        SubscribeButton(
          productId: planId.value,
          onUnsubscribe: () => onUnsubscribe(planId.value!),
        ),
      ],
    );
  }

  void onUnsubscribe(String sku) async {
    final info = await PackageInfo.fromPlatform();
    final packageId = info.packageName;

    final url =
        'https://play.google.com/store/account/subscriptions?sku=$sku&package=$packageId';
    launchUrl(Uri.parse(url));
  }
}
