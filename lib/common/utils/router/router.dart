import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/common/utils/router/router.gr.dart';

import '../../../feature/auth/sign_up/view/create.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),

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
        AutoRoute(page: HomeWrapper.page),

        AutoRoute(page: PreferenceRoute.page),
        AutoRoute(page: InterestRoute.page)
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

  static Route createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignUpCreateScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
