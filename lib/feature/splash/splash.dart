import 'package:auto_route/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

import '../../common/utils/utils.dart';
import '../../constants/index.dart';
import '../../provider/provider.dart';
import '../auth/sign_up/data/repository/user_repository.dart';

@RoutePage()
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final _userRepo = UserRepository();

  @override
  void initState() {
    _checkAuthentication();

    _checkLocationPermissionState();

    super.initState();
  }

  void _checkLocationPermissionState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SwipeAndMatchNotifier>()
        ..checkLocationPermissionState()
        ..checkTutorialTakenState();
    });
  }

  Future<void> _checkAuthentication() async {
    User? user = FirebaseAuth.instance.currentUser;

    // Ensure there's a fallback after a timeout (e.g., 5 seconds) to avoid hanging
    final fallbackTimer =
        Future.delayed(const Duration(seconds: 10), onUnAuthUser);

    if (user != null) {
      await _userRepo.accountCheck(
        enablePhoneCheck: true,
        user: user,
        showSnackbar: (_) {},
        onAuthenticate: () {
          fallbackTimer.ignore();
          onAuthenticate();
        },
        toCreateAccount: () {
          fallbackTimer.ignore();
          onUnAuthUser();
        },
        toOnboarding: () {
          fallbackTimer.ignore();
          onUnAuthUser();
        },
      );
    } else {
      await Future.delayed(const Duration(seconds: 2));
      fallbackTimer.ignore();
      onUnAuthUser();
    }
  }

  onAuthenticate() {
    if (mounted) {
      return Nav.replace(context, HomeWrapper());
    }
  }

  onUnAuthUser() {
    if (mounted) {
      Nav.replace(context, const SplashRoute());
    }
  }

  doNothing() {}

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.splash,
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.square(
                  dimension: 45.r,
                  child: SvgPicture.asset(AppAssets.logo),
                ),
                addWidth(10),
                SizedBox.square(
                  dimension: 130.r,
                  child: SvgPicture.asset(AppAssets.whossy),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
