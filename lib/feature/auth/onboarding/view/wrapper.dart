import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:whossy_mobile_app/common/components/Button/skip_button.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/data/state/onboarding_notifier.dart';

import '../../../../common/styles/component_style.dart';
import '../../../../common/utils/index.dart';
import '../../../../constants/index.dart';
import 'index.dart';
import 'onboarding_upload.dart';

@RoutePage()
class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> with TickerProviderStateMixin {
  late StreamSubscription subscription;
  late AnimationController _controller;
  late PageController _pageController;
  late List<Widget> _pages;

  late bool _isConnected;

  set connected(bool value) {
    setState(() => _isConnected = value);
  }

  int _activePage = 0;

  @override
  void initState() {
    super.initState();

    _controller = BottomSheet.createAnimationController(this)
      ..duration = const Duration(milliseconds: 400)
      ..reverseDuration = const Duration(milliseconds: 400);

    _pageController = PageController();

    _pages = [
      const RelPrefScreen(pageIndex: 0),
      const MeetScreen(pageIndex: 1),
      const AgeScreen(pageIndex: 2),
      const DistanceScreen(pageIndex: 3),
      const TickScreen(pageIndex: 4),
      const EducationScreen(pageIndex: 5),
      const DrinkScreen(pageIndex: 6),
      const SmokerScreen(pageIndex: 7),
      const PetsScreen(pageIndex: 8),
      const BioScreen(pageIndex: 9),
      const PictureScreen(pageIndex: 10),
    ];

    subscription = Connectivity().onConnectivityChanged.listen((_) async {
      connected = await InternetConnectionChecker().hasConnection;
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
    _pageController.dispose();
  }

  String buttonText(int count) {
    return _activePage == 4
        ? count < 5
            ? 'Select $count / 5'
            : 'Continue'
        : _activePage == _pages.length - 1
            ? 'Get Started'
            : 'Continue';
  }

  Color? updateColor(int count) {
    if (_activePage == 4 && count < 5) {
      return AppColors.backButtonColor;
    }

    return null;
  }

  void _onPageChange(int page) {
    setState(() => _activePage = page);
  }

  void _handleContinueButton({OnboardingNotifier? boarding}) {
    if (_activePage < _pages.length - 1) {
      _onPageUpdate(_activePage + 1);
    } else {
      if (_isConnected) {
        showLoadingSheet(context, _controller);
        boarding!.uploadPreferences(
          showSnackbar: (_) => showSnackbar(context, _),
          onAuthenticate: goToNext,
        );
      } else {
        showSnackbar(context, AppStrings.deviceOffline, pop: false);
      }
    }
  }

  goToNext() => Nav.replace(context, const HomeRoute());

  showSnackbar(BuildContext context, String message, {bool pop = true}) {
    if (mounted) {
      if (pop) Navigator.of(context).pop();
      showTopSnackBar(Overlay.of(context), AppSnackbar(text: message));
    }
  }

  void _onPageUpdate(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 22.h, left: 14.w, right: 14.w),
            child: PageIndicator(
              activePage: _activePage,
              pageNo: _pages.length,
            ),
          ),
          PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: _onPageChange,
            itemBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.only(top: 40.h, left: 14.w, right: 14.w),
                child: _pages[index],
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h, left: 14.w, right: 14.w),
              child: Row(
                children: [
                  Selector<OnboardingNotifier, bool>(
                    selector: (_, auth) => auth.spinnerState,
                    builder: (_, spinner, __) {
                      return AnimatedOpacity(
                        opacity: _activePage != 0 ? 1.0 : 0.0,
                        duration: const Duration(seconds: 1),
                        child: _activePage != 0
                            ? Row(
                                children: [
                                  FilledBackButton(
                                    onTap: () => _onPageUpdate(_activePage - 1),
                                    isDisabled: spinner,
                                  ),
                                  addWidth(4.w),
                                ],
                              )
                            : const SizedBox.shrink(),
                      );
                    },
                  ),
                  Expanded(
                    child: Consumer<OnboardingNotifier>(
                      builder: (_, boarding, __) {
                        return AppButton(
                          loading: boarding.spinnerState,
                          color: updateColor(boarding.ticks),
                          onPress: boarding.isSelected(_activePage)
                              ? () => _handleContinueButton(boarding: boarding)
                              : null,
                          text: buttonText(boarding.ticks),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 38.h, left: 14.w),
            child: SkipButton(
              page: _activePage,
              onTap: () => _handleContinueButton(),
            ),
          ),
        ],
      ),
    );
  }
}

const minSize = 0.4;
const maxSize = 0.5;

void showLoadingSheet(BuildContext ctx, AnimationController ctr) {
  showModalBottomSheet<void>(
    transitionAnimationController: ctr,
    showDragHandle: false,
    enableDrag: false,
    isScrollControlled: true,
    clipBehavior: Clip.hardEdge,
    isDismissible: false,
    context: ctx,
    shape: roundedTop,
    builder: (_) => PopScope(
      canPop: false,
      child: DraggableScrollableSheet(
        shouldCloseOnMinExtent: false,
        expand: false,
        initialChildSize: minSize,
        minChildSize: minSize,
        maxChildSize: maxSize,
        builder: (_, __) => const OnboardingUpload(),
      ),
    ),
  );
}
