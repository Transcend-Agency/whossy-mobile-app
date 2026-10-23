import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/components/components.dart';

import '../../common/utils/services/services.dart';
import '../../common/utils/utils.dart';
import '../../provider/provider.dart';
import '../auth/sign_up/data/repository/user_repository.dart';
import 'Tour/view/guided_tour.dart';
import 'Tour/view/intro_tour.dart';
import 'tabs/_.dart';
import 'tabs/explore/data/state/scroll_visibility_notifier.dart';
import 'tabs/matching/data/state/location_permission_stream.dart';
import 'widgets/account_gate.dart';
import 'widgets/verification_status_banner.dart';

@RoutePage()
class HomeWrapper extends StatefulWidget {
  const HomeWrapper({
    super.key,
    this.fromOnboarding = false,
  });

  final bool fromOnboarding;

  static String tutorial = 'Tour';

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  // Setup the location permission stream and service
  late Stream<LocationPermission> locationPermissionStream;
  final locationService = LocationService();
  late UserPresenceService _userService;
  late UserRepository _userRepository;

  // Set up the notifiers
  late EditProfileNotifier _editProfileNotifier;
  late SwipeAndMatchNotifier _swipeAndMatchNotifier;
  late PreferencesNotifier _prefsNotifier;
  late AdvancedSearchNotifier _advancedSearchNotifier;

  // Other UI code
  late List<Widget> _pages;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _pages = [
      const Explore(),
      const Matching(),
      const LikesAndMatch(),
      const Chat(),
      Profile(onStartTour: startTour),
    ];

    _editProfileNotifier = context.read<EditProfileNotifier>();
    _swipeAndMatchNotifier = context.read<SwipeAndMatchNotifier>();
    _advancedSearchNotifier = context.read<AdvancedSearchNotifier>();
    _prefsNotifier = context.read<PreferencesNotifier>();
    _userService = UserPresenceService();
    _userRepository = UserRepository();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _editProfileNotifier
        ..getUserData(showSnackbar: showAppSnackbar)
        ..checkSafetyGuideOpenedState()
        ..listenToFaceVerificationStatus(onRejected: showAppSnackbar);
      _prefsNotifier.getMatchingPreferences(showSnackbar: showAppSnackbar);
      _advancedSearchNotifier.getMatchingPreferences(
        showSnackbar: showAppSnackbar,
      );
      context.read<ChatsNotifier>().checkOpenedState();
      _userService.updateUserStatus(true);
      _userRepository.addUserToken();
    });

    _requestLocationPermission();

    startIntroTutorial(
      context: context,
      swipeAndMatchNotifier: _swipeAndMatchNotifier,
    );
  }

  void startTour() => startGuidedTutorial(context);

  Future<void> _requestLocationPermission() async {
    try {
      // Try to get the location
      final position = await LocationService.determinePosition(
        _swipeAndMatchNotifier.hasDeniedLocationPermission,
      );

      if (position != null) {
        await locationService.updateUserLocation(position);

        _editProfileNotifier.saveUserLocationLocally(
          position,
          showSnackbar: showAppSnackbar,
        );
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

  showAppSnackbar(String msg) => showSnackbar(msg, context);

  @override
  Widget build(BuildContext context) {
    return AccountGate(child: _home(context));
  }

  Widget _home(BuildContext context) {
    // Read the inset here: the fixed-height nav box below would otherwise
    // lose its own padding to the system buttons (3-button navigation).
    final systemBottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final navHeight = kFloatingNavHeight + 16 + systemBottomInset;
    return StreamProvider<LocationPermission>(
      create: (_) => createLifecycleAwarePermissionStream(),
      initialData: LocationPermission.denied,
      child: ChangeNotifierProvider(
        create: (_) => ScrollVisibilityNotifier(),
        child: Consumer<ScrollVisibilityNotifier>(
          builder: (context, scrollNotifier, child) {
            return AppScaffold(
              applyTop: false,
              maxContentWidth: null,
              body: VerificationStatusBanner(
                child: Builder(
                  builder: (_) => _pages.elementAt(
                    context.watch<TourNotifier>().currentIndex,
                  ),
                ),
              ),
              bottomNavBar: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                height: scrollNotifier.isVisible ? navHeight : 0,
                child: ClipRect(
                  child: OverflowBox(
                    alignment: Alignment.topCenter,
                    minHeight: navHeight,
                    maxHeight: navHeight,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        6,
                        16,
                        systemBottomInset + 10,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(maxWidth: kMaxContentWidth),
                          child: CustomBottomAppBar(items: bottomNavItems),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
