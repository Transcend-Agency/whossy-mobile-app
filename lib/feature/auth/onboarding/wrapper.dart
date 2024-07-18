import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/age_screen.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/bio_screen.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/distance_screen.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/drink_screen.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/education_screen.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/meet_screen.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/pets_screen.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/picture_screen.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/rel_pref_screen.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/smoker_screen.dart';
import 'package:whossy_mobile_app/feature/auth/onboarding/tick_screen.dart';

import '../../../common/utils/index.dart';

@RoutePage()
class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late PageController _pageController;
  late List<Widget> _pages;

  Preference? _selectedPreference;
  int _activePage = 0;

  void updatePreference(Preference? pref) {
    setState(() => _selectedPreference = pref);
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    _pages = [
      RelPrefScreen(onPreferenceSelected: updatePreference),
      const MeetScreen(),
      const AgeScreen(),
      const DistanceScreen(),
      const TickScreen(),
      const EducationScreen(),
      const DrinkScreen(),
      const SmokerScreen(),
      const PetsScreen(),
      const BioScreen(),
      const PictureScreen(),
    ];
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  void _onPageChange(int page) {
    setState(() {
      _activePage = page;
    });
  }

  void _handleContinueButton() {
    if (_selectedPreference != null && _activePage < _pages.length - 1) {
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
                    child: AppButton(
                      onPress: _selectedPreference != null
                          ? _handleContinueButton
                          : null,
                      text: 'Continue',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
