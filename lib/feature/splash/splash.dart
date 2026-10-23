import 'package:auto_route/auto_route.dart';
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

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  final _userRepo = UserRepository();

  /// The opening animation. The native launch screen is plain brand orange, so
  /// the first frame here matches it and everything builds up from there.
  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1700),
  );

  /// Gradient fading in over the native launch screen's solid orange.
  late final _gradientIn = _phase(0.0, 0.2, Curves.easeOut);

  /// Logo popping in at the centre of the screen.
  late final _logoScale = Tween(begin: 0.5, end: 1.0)
      .animate(_phase(0.08, 0.45, Curves.easeOutBack));
  late final _logoFade = _phase(0.08, 0.3, Curves.easeOut);

  /// Wordmark unrolling beside the logo, which slides left to make room.
  late final _wordmarkIn = _phase(0.45, 0.85, Curves.easeOutCubic);

  /// One heartbeat on the logo to finish.
  late final _heartbeat = TweenSequence([
    TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.12), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 1.12, end: 1.0), weight: 1),
  ]).animate(_phase(0.85, 1.0, Curves.easeInOut));

  CurvedAnimation _phase(double begin, double end, Curve curve) =>
      CurvedAnimation(parent: _intro, curve: Interval(begin, end, curve: curve));

  /// Completes once the intro has played (or been skipped), plus a short beat
  /// to take it in.
  late final Future<void> _introDone;

  bool _left = false;

  @override
  void initState() {
    _introDone = _intro.forward().orCancel.catchError((_) {}).then(
        (_) => Future.delayed(const Duration(milliseconds: 250)));

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
      fallbackTimer.ignore();
      onUnAuthUser();
    }
  }

  onAuthenticate() => _leaveFor(HomeWrapper());

  onUnAuthUser() => _leaveFor(const SplashRoute());

  /// Leaves once the intro has finished, so it is never cut off midway. Only
  /// the first caller goes; the fallback timer can still fire later.
  Future<void> _leaveFor(PageRouteInfo route) async {
    await _introDone;
    if (!mounted || _left) return;
    _left = true;
    Nav.replace(context, route);
  }

  doNothing() {}

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Respect the system "remove animations" setting.
    if (MediaQuery.disableAnimationsOf(context)) _intro.value = 1;
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.premiumContainer,
      child: FadeTransition(
        opacity: _gradientIn,
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.splash,
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _intro,
              builder: (context, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Opacity(
                    opacity: _logoFade.value,
                    child: Transform.scale(
                      scale: _logoScale.value * _heartbeat.value,
                      child: SizedBox.square(
                        dimension: 45.r,
                        child: SvgPicture.asset(AppAssets.logo),
                      ),
                    ),
                  ),
                  addWidth(10 * _wordmarkIn.value),
                  // Grows from zero width, so the row stays centred and the
                  // logo glides left as the wordmark is revealed.
                  ClipRect(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: _wordmarkIn.value,
                      child: Opacity(
                        opacity: _wordmarkIn.value,
                        child: Transform.translate(
                          offset: Offset(-16 * (1 - _wordmarkIn.value), 0),
                          child: SizedBox(
                            width: 130.r,
                            child: SvgPicture.asset(AppAssets.whossy),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
