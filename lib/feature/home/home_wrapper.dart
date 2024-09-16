import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/constants/asset_paths.dart';

import '../../provider/providers.dart';
import 'tabs/_.dart';

@RoutePage()
class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  late EditProfileNotifier _editProfileNotifier;
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

    _editProfileNotifier = context.read<EditProfileNotifier>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _editProfileNotifier.getUserData(showSnackbar: showSnackbar);

      _editProfileNotifier.checkOpenedState();
    });

    super.initState();
  }

  void _selectedTab(int index) {
    setState(() => selectedIndex = index);
  }

  showSnackbar(String message) {
    if (mounted) {
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
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
    );
  }
}

class AppBarItem {}
