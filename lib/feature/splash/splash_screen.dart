import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whossy_mobile_app/common/components/Slider/splash_slider.dart';
import 'package:whossy_mobile_app/common/utils/widget_functions.dart';

import '../../common/components/Box/icon_box.dart';
import '../../common/components/Button/app_button.dart';
import '../../common/components/Text/gradient_text.dart';
import '../../common/styles/text_style.dart';
import '../../constants/asset_paths.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';

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

  @override
  void initState() {
    super.initState();
    _scrollController1 = ScrollController();
    _scrollController2 = ScrollController();
    _scrollController3 = ScrollController();
    _scrollController4 = ScrollController();

    // Animate each slider after the frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Start first and third controllers from the beginning
      animateToMaxMin(
        _scrollController1,
        _scrollController1.position.maxScrollExtent,
        _scrollController1.position.minScrollExtent,
        _scrollController1.position.maxScrollExtent,
        25,
      );
      animateToMaxMin(
        _scrollController3,
        _scrollController3.position.maxScrollExtent,
        _scrollController3.position.minScrollExtent,
        _scrollController3.position.maxScrollExtent,
        15,
      );

      // Start the second and fourth controllers from the end
      _scrollController2.jumpTo(_scrollController2.position.maxScrollExtent);
      animateToMaxMin(
        _scrollController2,
        _scrollController2.position.maxScrollExtent,
        _scrollController2.position.minScrollExtent,
        _scrollController2.position.minScrollExtent,
        20,
      );
      _scrollController4.jumpTo(_scrollController4.position.maxScrollExtent);
      animateToMaxMin(
        _scrollController4,
        _scrollController4.position.maxScrollExtent,
        _scrollController4.position.minScrollExtent,
        _scrollController4.position.minScrollExtent,
        18,
      );
    });
  }

  void animateToMaxMin(
    ScrollController controller,
    double max,
    double min,
    double direction,
    int seconds,
  ) {
    controller
        .animateTo(
      direction,
      duration: Duration(seconds: seconds),
      curve: Curves.linear,
    )
        .then((_) {
      direction = direction == max ? min : max;
      animateToMaxMin(controller, max, min, direction, seconds);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  addHeight(10),
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
                      decoration:
                          BoxDecoration(gradient: AppColors.splashShade),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 16.w, right: 16.w, top: 110.w),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
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
                            addHeight(32),
                            AppButton(onPress: () {}, text: 'Login'),
                            addHeight(14),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: AppStrings.noAccount,
                                    style: TextStyles.miniText,
                                  ),
                                  TextSpan(
                                    text: AppStrings.cAccount,
                                    style: TextStyles.miniText.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => {},
                                  ),
                                ],
                              ),
                            ),
                            addHeight(20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
