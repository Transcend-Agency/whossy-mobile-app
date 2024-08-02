// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i15;
import 'package:flutter/material.dart' as _i16;
import 'package:whossy_mobile_app/feature/auth/login/view/login_screen.dart'
    as _i2;
import 'package:whossy_mobile_app/feature/auth/login/view/phone_number_screen.dart'
    as _i3;
import 'package:whossy_mobile_app/feature/auth/login/view/reset_screen.dart'
    as _i4;
import 'package:whossy_mobile_app/feature/auth/login/view/reset_success_screen.dart'
    as _i5;
import 'package:whossy_mobile_app/feature/auth/login/view/verification_code_screen.dart'
    as _i12;
import 'package:whossy_mobile_app/feature/auth/onboarding/view/wrapper.dart'
    as _i14;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/create.dart' as _i6;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/gender.dart' as _i7;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/name.dart' as _i8;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/phone.dart' as _i9;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/verification.dart'
    as _i10;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/welcome.dart'
    as _i13;
import 'package:whossy_mobile_app/feature/home/home_screen.dart' as _i1;
import 'package:whossy_mobile_app/feature/splash/splash_screen.dart' as _i11;

abstract class $AppRouter extends _i15.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i15.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeScreen(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.LoginScreen(),
      );
    },
    PhoneNumberRoute.name: (routeData) {
      final args = routeData.argsAs<PhoneNumberRouteArgs>(
          orElse: () => const PhoneNumberRouteArgs());
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.PhoneNumberScreen(
          key: args.key,
          signIn: args.signIn,
        ),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.ResetPasswordScreen(),
      );
    },
    ResetSuccessRoute.name: (routeData) {
      final args = routeData.argsAs<ResetSuccessRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.ResetSuccessScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
    SignUpCreateRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.SignUpCreateScreen(),
      );
    },
    SignUpGenderRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i7.SignUpGenderScreen(),
      );
    },
    SignUpNameRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.SignUpNameScreen(),
      );
    },
    SignUpPhoneRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SignUpPhoneScreen(),
      );
    },
    SignUpVerificationRoute.name: (routeData) {
      final args = routeData.argsAs<SignUpVerificationRouteArgs>(
          orElse: () => const SignUpVerificationRouteArgs());
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i10.SignUpVerificationScreen(
          key: args.key,
          pop: args.pop,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SplashScreen(),
      );
    },
    VerificationCodeRoute.name: (routeData) {
      final args = routeData.argsAs<VerificationCodeRouteArgs>();
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.VerificationCodeScreen(
          key: args.key,
          phone: args.phone,
          verId: args.verId,
          signIn: args.signIn,
        ),
      );
    },
    WelcomeRoute.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.WelcomeScreen(),
      );
    },
    Wrapper.name: (routeData) {
      return _i15.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i14.Wrapper(),
      );
    },
  };
}

/// generated route for
/// [_i1.HomeScreen]
class HomeRoute extends _i15.PageRouteInfo<void> {
  const HomeRoute({List<_i15.PageRouteInfo>? children})
      : super(
          HomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i2.LoginScreen]
class LoginRoute extends _i15.PageRouteInfo<void> {
  const LoginRoute({List<_i15.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i3.PhoneNumberScreen]
class PhoneNumberRoute extends _i15.PageRouteInfo<PhoneNumberRouteArgs> {
  PhoneNumberRoute({
    _i16.Key? key,
    bool signIn = true,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          PhoneNumberRoute.name,
          args: PhoneNumberRouteArgs(
            key: key,
            signIn: signIn,
          ),
          initialChildren: children,
        );

  static const String name = 'PhoneNumberRoute';

  static const _i15.PageInfo<PhoneNumberRouteArgs> page =
      _i15.PageInfo<PhoneNumberRouteArgs>(name);
}

class PhoneNumberRouteArgs {
  const PhoneNumberRouteArgs({
    this.key,
    this.signIn = true,
  });

  final _i16.Key? key;

  final bool signIn;

  @override
  String toString() {
    return 'PhoneNumberRouteArgs{key: $key, signIn: $signIn}';
  }
}

/// generated route for
/// [_i4.ResetPasswordScreen]
class ResetPasswordRoute extends _i15.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i15.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i5.ResetSuccessScreen]
class ResetSuccessRoute extends _i15.PageRouteInfo<ResetSuccessRouteArgs> {
  ResetSuccessRoute({
    _i16.Key? key,
    required String email,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          ResetSuccessRoute.name,
          args: ResetSuccessRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ResetSuccessRoute';

  static const _i15.PageInfo<ResetSuccessRouteArgs> page =
      _i15.PageInfo<ResetSuccessRouteArgs>(name);
}

class ResetSuccessRouteArgs {
  const ResetSuccessRouteArgs({
    this.key,
    required this.email,
  });

  final _i16.Key? key;

  final String email;

  @override
  String toString() {
    return 'ResetSuccessRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i6.SignUpCreateScreen]
class SignUpCreateRoute extends _i15.PageRouteInfo<void> {
  const SignUpCreateRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SignUpCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpCreateRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i7.SignUpGenderScreen]
class SignUpGenderRoute extends _i15.PageRouteInfo<void> {
  const SignUpGenderRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SignUpGenderRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpGenderRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i8.SignUpNameScreen]
class SignUpNameRoute extends _i15.PageRouteInfo<void> {
  const SignUpNameRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SignUpNameRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpNameRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SignUpPhoneScreen]
class SignUpPhoneRoute extends _i15.PageRouteInfo<void> {
  const SignUpPhoneRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SignUpPhoneRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpPhoneRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i10.SignUpVerificationScreen]
class SignUpVerificationRoute
    extends _i15.PageRouteInfo<SignUpVerificationRouteArgs> {
  SignUpVerificationRoute({
    _i16.Key? key,
    bool pop = false,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          SignUpVerificationRoute.name,
          args: SignUpVerificationRouteArgs(
            key: key,
            pop: pop,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpVerificationRoute';

  static const _i15.PageInfo<SignUpVerificationRouteArgs> page =
      _i15.PageInfo<SignUpVerificationRouteArgs>(name);
}

class SignUpVerificationRouteArgs {
  const SignUpVerificationRouteArgs({
    this.key,
    this.pop = false,
  });

  final _i16.Key? key;

  final bool pop;

  @override
  String toString() {
    return 'SignUpVerificationRouteArgs{key: $key, pop: $pop}';
  }
}

/// generated route for
/// [_i11.SplashScreen]
class SplashRoute extends _i15.PageRouteInfo<void> {
  const SplashRoute({List<_i15.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i12.VerificationCodeScreen]
class VerificationCodeRoute
    extends _i15.PageRouteInfo<VerificationCodeRouteArgs> {
  VerificationCodeRoute({
    _i16.Key? key,
    required String phone,
    required String verId,
    bool signIn = true,
    List<_i15.PageRouteInfo>? children,
  }) : super(
          VerificationCodeRoute.name,
          args: VerificationCodeRouteArgs(
            key: key,
            phone: phone,
            verId: verId,
            signIn: signIn,
          ),
          initialChildren: children,
        );

  static const String name = 'VerificationCodeRoute';

  static const _i15.PageInfo<VerificationCodeRouteArgs> page =
      _i15.PageInfo<VerificationCodeRouteArgs>(name);
}

class VerificationCodeRouteArgs {
  const VerificationCodeRouteArgs({
    this.key,
    required this.phone,
    required this.verId,
    this.signIn = true,
  });

  final _i16.Key? key;

  final String phone;

  final String verId;

  final bool signIn;

  @override
  String toString() {
    return 'VerificationCodeRouteArgs{key: $key, phone: $phone, verId: $verId, signIn: $signIn}';
  }
}

/// generated route for
/// [_i13.WelcomeScreen]
class WelcomeRoute extends _i15.PageRouteInfo<void> {
  const WelcomeRoute({List<_i15.PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}

/// generated route for
/// [_i14.Wrapper]
class Wrapper extends _i15.PageRouteInfo<void> {
  const Wrapper({List<_i15.PageRouteInfo>? children})
      : super(
          Wrapper.name,
          initialChildren: children,
        );

  static const String name = 'Wrapper';

  static const _i15.PageInfo<void> page = _i15.PageInfo<void>(name);
}
