import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:whossy_app/common/components/index.dart';
import 'package:whossy_app/feature/home/tutorial.dart';

import '../../common/styles/text_style.dart';
import '../../common/utils/index.dart';
import '../../common/utils/services/services.dart';
import '../../constants/index.dart';
import '../../provider/providers.dart';
import 'tabs/_.dart';
import 'tabs/matching/data/state/location_permission_stream.dart';

@RoutePage()
class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  static String tutorial = 'Tutorial';

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  // Setup the location permission stream and service
  late Stream<LocationPermission> locationPermissionStream;
  final locationService = LocationService();

  // Set up the notifiers
  late EditProfileNotifier _editProfileNotifier;
  late SwipeAndMatchNotifier _swipeAndMatchNotifier;
  late PreferencesNotifier _prefsNotifier;

  // Other UI code
  late List<Widget> _pages;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _pages = [
      const Matching(),
      const Explore(),
      const LikesAndMatch(),
      const Chat(),
      const Profile(),
    ];

    _editProfileNotifier = context.read<EditProfileNotifier>();
    _swipeAndMatchNotifier = context.read<SwipeAndMatchNotifier>();
    _prefsNotifier = context.read<PreferencesNotifier>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _editProfileNotifier.getUserData(showSnackbar: showSnackbar);
      _editProfileNotifier.checkSafetyGuideOpenedState();
      _prefsNotifier.getMatchingPreferences(showSnackbar: showSnackbar);
      context.read<ChatsNotifier>().checkOpenedState();
    });

    _requestLocationPermission();

    startTutorial();
  }

  Future<void> _requestLocationPermission() async {
    try {
      // Try to get the location
      final position = await LocationService.determinePosition(
        _swipeAndMatchNotifier.hasDeniedLocationPermission,
      );

      if (position != null) {
        await locationService.updateUserLocation(position);
      }
    } catch (e) {
      if (e is LocationPermissionDeniedException) {
        await _showPermissionDialog(e.message);

        _swipeAndMatchNotifier.hasDeniedLocationPermission = true;
      } else {
        log('An error occurred while requesting location permission $e');
      }
    }
  }

  Future<void>? _showPermissionDialog(String message) async {
    bool? result = await showConfirmationDialog(
      context,
      title: 'Permission Denied',
      content: contentText(message),
      yes: 'Open settings',
      no: 'Cancel',
    );

    if (result == null) return;

    if (result && mounted) {
      await openAppSettings();
    }
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
    return StreamProvider<LocationPermission>(
      create: (_) => createLifecycleAwarePermissionStream(),
      initialData: LocationPermission.denied,
      child: AppScaffold(
        applyTop: false,
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

  void startTutorial() {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (!_swipeAndMatchNotifier.hasTakenTutorial) {
          TutorialCoachMark(
            paddingFocus: 0,
            targets: targets,
            colorShadow: Colors.black.withOpacity(0.3),
            skipWidget: Text(
              'Skip',
              style: TextStyles.boldPrefText.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: AppUtils.scale(15.sp) ?? 16.5.sp,
                color: Colors.white,
              ),
            ),
            onFinish: () => _swipeAndMatchNotifier.hasTakenTutorial = true,
          ).show(context: context);
        }
      },
    );
  }
}
