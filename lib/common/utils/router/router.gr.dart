// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:whossy_mobile_app/feature/auth/login/login_screen.dart' as _i1;
import 'package:whossy_mobile_app/feature/auth/login/reset_screen.dart' as _i2;
import 'package:whossy_mobile_app/feature/auth/onboarding/wrapper.dart' as _i9;
import 'package:whossy_mobile_app/feature/auth/sign_up/create.dart' as _i3;
import 'package:whossy_mobile_app/feature/auth/sign_up/gender.dart' as _i4;
import 'package:whossy_mobile_app/feature/auth/sign_up/name.dart' as _i5;
import 'package:whossy_mobile_app/feature/auth/sign_up/phone.dart' as _i6;
import 'package:whossy_mobile_app/feature/auth/sign_up/welcome.dart' as _i8;
import 'package:whossy_mobile_app/feature/splash/splash_screen.dart' as _i7;

abstract class $AppRouter extends _i10.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.LoginScreen(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.ResetPasswordScreen(),
      );
    },
    SignUpCreateRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.SignUpCreateScreen(),
      );
    },
    SignUpGenderRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.SignUpGenderScreen(),
      );
    },
    SignUpNameRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.SignUpNameScreen(),
      );
    },
    SignUpPhoneRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SignUpPhoneScreen(),
      );
    },
    SplashRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SplashScreen(),
      );
    },
    WelcomeRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.WelcomeScreen(),
      );
    },
    Wrapper.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.Wrapper(),
      );
    },
  };
}

/// generated route for
/// [_i1.LoginScreen]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute({List<_i10.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i2.ResetPasswordScreen]
class ResetPasswordRoute extends _i10.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i10.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i3.SignUpCreateScreen]
class SignUpCreateRoute extends _i10.PageRouteInfo<void> {
  const SignUpCreateRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SignUpCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpCreateRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i4.SignUpGenderScreen]
class SignUpGenderRoute extends _i10.PageRouteInfo<void> {
  const SignUpGenderRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SignUpGenderRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpGenderRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i5.SignUpNameScreen]
class SignUpNameRoute extends _i10.PageRouteInfo<void> {
  const SignUpNameRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SignUpNameRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpNameRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i6.SignUpPhoneScreen]
class SignUpPhoneRoute extends _i10.PageRouteInfo<void> {
  const SignUpPhoneRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SignUpPhoneRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpPhoneRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SplashScreen]
class SplashRoute extends _i10.PageRouteInfo<void> {
  const SplashRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i8.WelcomeScreen]
class WelcomeRoute extends _i10.PageRouteInfo<void> {
  const WelcomeRoute({List<_i10.PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i9.Wrapper]
class Wrapper extends _i10.PageRouteInfo<void> {
  const Wrapper({List<_i10.PageRouteInfo>? children})
      : super(
          Wrapper.name,
          initialChildren: children,
        );

  static const String name = 'Wrapper';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}
