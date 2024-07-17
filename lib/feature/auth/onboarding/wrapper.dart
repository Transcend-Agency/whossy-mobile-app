import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/components/index.dart';
import 'package:whossy_mobile_app/common/styles/component_style.dart';
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

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();

    _pageController.dispose();
  }

  int _activePage = 0;

  final _pages = [
    const RelPrefScreen(),
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

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      padding: pagePadding,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 22.h),
            child: PageIndicator(
              activePage: _activePage,
              pageNo: _pages.length,
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (page) {
              setState(() => _activePage = page);
            },
            itemBuilder: (_, index) {
              return Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: _pages[index],
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  AnimatedOpacity(
                    opacity: _activePage != 0 ? 1.0 : 0.0,
                    duration: const Duration(seconds: 1),
                    child: _activePage != 0
                        ? Row(
                            children: [
                              const FilledBackButton(),
                              addWidth(4.w),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                  AppButton(
                    onPress: () {},
                    text: 'Continue',
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
