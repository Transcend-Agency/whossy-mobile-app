import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/components/index.dart';
import '../../common/styles/text_style.dart';
import '../../common/utils/index.dart';
import '../../common/utils/router/router.gr.dart';
import '../../constants/index.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ScrollController _scrollController1;
  late ScrollController _scrollController2;
  late ScrollController _scrollController3;
  late ScrollController _scrollController4;

  int time = 25;

  @override
  void initState() {
    super.initState();
    _scrollController1 = ScrollController();
    _scrollController2 = ScrollController();
    _scrollController3 = ScrollController();
    _scrollController4 = ScrollController();

    // Animate each slider after the frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration.zero, () {
        // Start first and third controllers from the beginning
        animateToMaxMin(
          _scrollController1,
          _scrollController1.position.maxScrollExtent,
          _scrollController1.position.minScrollExtent,
          _scrollController1.position.maxScrollExtent,
          time,
        );
        animateToMaxMin(
          _scrollController3,
          _scrollController3.position.maxScrollExtent,
          _scrollController3.position.minScrollExtent,
          _scrollController3.position.maxScrollExtent,
          time,
        );

        // Start the second and fourth controllers from the end
        _scrollController2.jumpTo(_scrollController2.position.maxScrollExtent);
        animateToMaxMin(
          _scrollController2,
          _scrollController2.position.maxScrollExtent,
          _scrollController2.position.minScrollExtent,
          _scrollController2.position.minScrollExtent,
          time,
        );
        _scrollController4.jumpTo(_scrollController4.position.maxScrollExtent);
        animateToMaxMin(
          _scrollController4,
          _scrollController4.position.maxScrollExtent,
          _scrollController4.position.minScrollExtent,
          _scrollController4.position.minScrollExtent,
          time,
        );
      });
    });
  }

  void animateToMaxMin(
    ScrollController controller,
    double max,
    double min,
    double direction,
    int seconds,
  ) {
    if (!controller.hasClients) {
      return;
    }

    controller
        .animateTo(direction,
            duration: Duration(seconds: seconds), curve: Curves.linear)
        .then((_) {
      direction = direction == max ? min : max;
      animateToMaxMin(controller, max, min, direction, seconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SplashSlider(
                scrollController: _scrollController1,
                row: 1,
              ),
              SplashSlider(
                scrollController: _scrollController2,
                row: 2,
              ),
              SplashSlider(
                scrollController: _scrollController3,
                row: 3,
              ),
              SplashSlider(
                scrollController: _scrollController4,
                row: 4,
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(gradient: AppColors.splashShade),
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 14.w, right: 14.w, top: 110.w),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            const GradientText(
                              gradient: AppColors.splashGradient,
                            ),
                            Positioned(
                              right: 125.w,
                              top: 0,
                              bottom: 0,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const IconBox(
                                        iconPath: AppAssets.chatXIcon),
                                    addWidth(6),
                                    const IconBox(
                                        iconPath: AppAssets.chatLoveIcon),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        addHeight(30),
                        AppButton(
                          onPress: () => Nav.push(context, const LoginRoute()),
                          text: 'Login',
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 2.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppStrings.noAccount,
                                style: TextStyles.fieldHeader,
                              ),
                              TextButton(
                                onPressed: () => Nav.push(
                                    context, const SignUpCreateRoute()),
                                style: TextButton.styleFrom(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 7, 11, 7),
                                ),
                                child: Text(
                                  AppStrings.cAccount,
                                  style: TextStyles.privacyText,
                                ),
                              )
                            ],
                          ),
                        ),
                        addHeight(2),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController1.dispose();
    _scrollController2.dispose();
    _scrollController3.dispose();
    _scrollController4.dispose();
    super.dispose();
  }
}
