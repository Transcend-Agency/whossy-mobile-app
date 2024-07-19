import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:whossy_mobile_app/common/components/Button/skip_button.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/view/index.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/view_model/onboarding_provider.dart';

import '../../../../common/utils/index.dart';

@RoutePage()
class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late PageController _pageController;
  late List<Widget> _pages;

  int _activePage = 0;

  @override
  void initState() {
    super.initState();

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
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  String buttonText() {
    return _activePage == _pages.length - 1 ? 'Get Started' : 'Continue';
  }

  void _onPageChange(int page) {
    setState(() {
      _activePage = page;
    });
  }

  void _handleContinueButton() {
    log('Bams D');
    if (_activePage < _pages.length - 1) {
      _onPageUpdate(_activePage + 1);
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
            // physics: const NeverScrollableScrollPhysics(),
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
              padding: EdgeInsets.only(bottom: 20, left: 14.w, right: 14.w),
              child: Row(
                children: [
                  AnimatedOpacity(
                    opacity: _activePage != 0 ? 1.0 : 0.0,
                    duration: const Duration(seconds: 1),
                    child: _activePage != 0
                        ? Row(
                            children: [
                              FilledBackButton(
                                onTap: () => _onPageUpdate(_activePage - 1),
                              ),
                              addWidth(4.w),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                  Expanded(
                    child: Consumer<OnboardingProvider>(
                      builder: (_, boarding, __) {
                        return AppButton(
                          onPress: boarding.isSelected(_activePage)
                              ? _handleContinueButton
                              : null,
                          text: buttonText(),
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
              onTap: _handleContinueButton,
            ),
          ),
        ],
      ),
    );
  }
}
