import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/components/index.dart';

import '../model/credit.dart';
import 'plans/free_plan.dart';
import 'plans/premium_plan.dart';
import 'widgets/_.dart';

@RoutePage()
class SubscriptionPlans extends StatefulWidget {
  const SubscriptionPlans({
    super.key,
    required this.initialPage,
  }) : assert(initialPage == 0 || initialPage == 1,
            'Initial page must be 0 (Free Plan) or 1 (Premium Plan)');

  final int initialPage;

  @override
  State<SubscriptionPlans> createState() => _SubscriptionPlansState();
}

class _SubscriptionPlansState extends State<SubscriptionPlans> {
  late final ValueNotifier<Currency> userCurrency;
  late final PageController _pageController;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    userCurrency = ValueNotifier(Currency.USD);
    _pageController = PageController(initialPage: widget.initialPage);
    _pages = [
      const FreePlan(),
      PremiumPlan(userCurrency: userCurrency),
    ];
  }

  @override
  void dispose() {
    userCurrency.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: CustomAppBar(
        addBarHeight: 4,
        title: 'Subscription Plans',
        color: Colors.white,
        action: Padding(
          padding: EdgeInsets.only(right: 20.r),
          child: ValueListenableBuilder<Currency>(
            valueListenable: userCurrency,
            builder: (context, currency, _) {
              return CurrencyDropdown(
                selectedCurrency: currency,
                onCurrencyChanged: (newCurrency) {
                  if (newCurrency != null) {
                    userCurrency.value = newCurrency;
                  }
                },
              );
            },
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (page) {},
              itemBuilder: (_, index) {
                return _pages[index];
              },
            ),
          ),
        ],
      ),
    );
  }
}
