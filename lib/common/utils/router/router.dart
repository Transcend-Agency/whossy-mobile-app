import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page),

        // LOGIN
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: ResetPasswordRoute.page),
        AutoRoute(page: ResetSuccessRoute.page),
        AutoRoute(page: PhoneNumberRoute.page),
        AutoRoute(page: VerificationCodeRoute.page),

        // SIGN-UP
        AutoRoute(page: SignUpCreateRoute.page),
        AutoRoute(page: SignUpGenderRoute.page),
        AutoRoute(page: SignUpNameRoute.page),
        AutoRoute(page: SignUpPhoneRoute.page),
        AutoRoute(page: SignUpVerificationRoute.page),
        AutoRoute(page: WelcomeRoute.page),

        // ONBOARDING
        AutoRoute(page: Wrapper.page),
        // MAIN APP
        AutoRoute(page: HomeWrapper.page, initial: true),

        AutoRoute(page: PreferenceRoute.page),
        AutoRoute(page: InterestRoute.page),

        AutoRoute(page: Settings.page),
        AutoRoute(page: EditProfile.page),
        AutoRoute(page: PreviewProfile.page),
        AutoRoute(page: PreviewProfileMore.page),
      ];
}

class Nav {
  static Future<void> push(
      BuildContext context, PageRouteInfo<dynamic>? route) async {
    await context.router.push(route!);
  }

  static bool isRoot(BuildContext context) => context.router.isRoot;

  static Future<void> replaceAll(
      BuildContext context, List<PageRouteInfo<dynamic>> routes) async {
    await context.router.replaceAll(routes);
  }

  static Future<void> pushAndPopUntil(
      BuildContext context, PageRouteInfo<dynamic> route, String name) async {
    await context.router.pushAndPopUntil(
      route,
      predicate: (route) => route.settings.name == name,
    );
  }

  static Future<void> replace(
      BuildContext context, PageRouteInfo<dynamic> route) async {
    await context.router.replace(route);
  }
}

class SwipeTransitionRoute extends PageRouteBuilder {
  final Widget page;
  final double dragExtent;

  SwipeTransitionRoute({
    required this.page,
    required this.dragExtent,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: Interval(0.0, dragExtent, curve: Curves.easeInOut),
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: const Offset(0, 0),
              ).animate(curvedAnimation),
              child: child,
            );
          },
        );
}
