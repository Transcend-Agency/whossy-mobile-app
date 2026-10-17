import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/common/components/components.dart';

import 'plans/free_plan.dart';
import 'plans/premium_plan.dart';

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
  late final PageController _pageController;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Use stored currency if user is premium and it exists
    _pageController = PageController(initialPage: widget.initialPage);
    _pages = [
      const FreePlan(),
      PremiumPlan(),
    ];
  }

  @override
  void dispose() {
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
