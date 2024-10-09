import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_app/common/components/index.dart';

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
  late PageController _pageController;
  late List<Widget> _pages;

  int _activePage = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: widget.initialPage);

    _pages = [
      const FreePlan(),
      const PremiumPlan(),
    ];
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  void _onPageChange(int page) {
    setState(() => _activePage = page);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: const CustomAppBar(
        //addBarHeight: 10,
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
              onPageChanged: _onPageChange,
              itemBuilder: (_, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 14.r, right: 14.r, top: 16.r),
                  child: _pages[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
