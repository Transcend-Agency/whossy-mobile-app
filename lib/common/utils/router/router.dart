import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:whossy_app/common/utils/router/router.gr.dart';

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
        AutoRoute(page: InterestRoute.page),

        // Profile / Tab 5
        AutoRoute(page: Settings.page),
        AutoRoute(page: EditProfile.page),
        AutoRoute(page: NameEditProfile.page),
        AutoRoute(page: PreviewProfile.page),
        AutoRoute(page: PreviewProfileMore.page),
        AutoRoute(page: SafetyGuide.page),

        // Likes and Match / Tab 3
        AutoRoute(page: MoreInfoRoute.page),

        // Chat / Tab 4
        AutoRoute(page: ChatRoom.page),
      ];
}

class Nav {
  static Future<void> push(
    BuildContext context,
    PageRouteInfo<dynamic>? route,
  ) async {
    await context.router.push(route!);
  }

  static Future<void> replaceAll(
    BuildContext context,
    List<PageRouteInfo<dynamic>> routes,
  ) async {
    await context.router.replaceAll(routes);
  }

  static Future<void> pushAndPopUntil(
    BuildContext context,
    PageRouteInfo<dynamic> route,
    String name,
  ) async {
    await context.router.pushAndPopUntil(
      route,
      predicate: (route) => route.settings.name == name,
    );
  }

  static Future<void> replace(
    BuildContext context,
    PageRouteInfo<dynamic> route,
  ) async {
    await context.router.replace(route);
  }

  // New popUntil method
  static void popUntil(BuildContext context, String routeName) {
    context.router.popUntil((route) => route.settings.name == routeName);
  }
}
