import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/constants/asset_paths.dart';

import 'tabs/_.dart';

@RoutePage()
class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  late List<Widget> _pages;
  int selectedIndex = 0;

  @override
  void initState() {
    _pages = [
      const Matching(),
      const Two(),
      const Three(),
      const Four(),
      const Profile(),
    ];
    super.initState();
  }

  void _selectedTab(int index) {
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AppScaffold(
        body: SizedBox(
          child: _pages.elementAt(selectedIndex),
        ),
        bottomNavBar: CustomBottomAppBar(
          onTabSelected: _selectedTab,
          items: const [
            AppAssets.fire,
            AppAssets.globalSearch,
            AppAssets.heart,
            AppAssets.chat,
            AppAssets.user,
          ],
        ),
      ),
    );
  }
}

class AppBarItem {}
