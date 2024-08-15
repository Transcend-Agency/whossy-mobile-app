// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i17;
import 'package:flutter/material.dart' as _i18;
import 'package:whossy_mobile_app/feature/auth/login/view/login_screen.dart'
    as _i3;
import 'package:whossy_mobile_app/feature/auth/login/view/phone_number_screen.dart'
    as _i4;
import 'package:whossy_mobile_app/feature/auth/login/view/reset_screen.dart'
    as _i6;
import 'package:whossy_mobile_app/feature/auth/login/view/reset_success_screen.dart'
    as _i7;
import 'package:whossy_mobile_app/feature/auth/login/view/verification_code_screen.dart'
    as _i14;
import 'package:whossy_mobile_app/feature/auth/onboarding/view/wrapper.dart'
    as _i16;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/create.dart' as _i8;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/gender.dart' as _i9;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/name.dart' as _i10;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/phone.dart' as _i11;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/verification.dart'
    as _i12;
import 'package:whossy_mobile_app/feature/auth/sign_up/view/welcome.dart'
    as _i15;
import 'package:whossy_mobile_app/feature/home/view/home_wrapper.dart' as _i1;
import 'package:whossy_mobile_app/feature/home/view/preference/interest_screen.dart'
    as _i2;
import 'package:whossy_mobile_app/feature/home/view/preference/preference_screen.dart'
    as _i5;
import 'package:whossy_mobile_app/feature/splash/splash_screen.dart' as _i13;

abstract class $AppRouter extends _i17.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i17.PageFactory> pagesMap = {
    HomeWrapper.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomeWrapper(),
      );
    },
    InterestRoute.name: (routeData) {
      final args = routeData.argsAs<InterestRouteArgs>(
          orElse: () => const InterestRouteArgs());
      return _i17.AutoRoutePage<List<String>>(
        routeData: routeData,
        child: _i2.InterestScreen(
          key: args.key,
          initialValues: args.initialValues,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i3.LoginScreen(),
      );
    },
    PhoneNumberRoute.name: (routeData) {
      final args = routeData.argsAs<PhoneNumberRouteArgs>(
          orElse: () => const PhoneNumberRouteArgs());
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i4.PhoneNumberScreen(
          key: args.key,
          signIn: args.signIn,
        ),
      );
    },
    PreferenceRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i5.PreferenceScreen(),
      );
    },
    ResetPasswordRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i6.ResetPasswordScreen(),
      );
    },
    ResetSuccessRoute.name: (routeData) {
      final args = routeData.argsAs<ResetSuccessRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.ResetSuccessScreen(
          key: args.key,
          email: args.email,
        ),
      );
    },
    SignUpCreateRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.SignUpCreateScreen(),
      );
    },
    SignUpGenderRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SignUpGenderScreen(),
      );
    },
    SignUpNameRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i10.SignUpNameScreen(),
      );
    },
    SignUpPhoneRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i11.SignUpPhoneScreen(),
      );
    },
    SignUpVerificationRoute.name: (routeData) {
      final args = routeData.argsAs<SignUpVerificationRouteArgs>(
          orElse: () => const SignUpVerificationRouteArgs());
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i12.SignUpVerificationScreen(
          key: args.key,
          pop: args.pop,
        ),
      );
    },
    SplashRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i13.SplashScreen(),
      );
    },
    VerificationCodeRoute.name: (routeData) {
      final args = routeData.argsAs<VerificationCodeRouteArgs>();
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i14.VerificationCodeScreen(
          key: args.key,
          phone: args.phone,
          verId: args.verId,
          signIn: args.signIn,
          resendToken: args.resendToken,
        ),
      );
    },
    WelcomeRoute.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i15.WelcomeScreen(),
      );
    },
    Wrapper.name: (routeData) {
      return _i17.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i16.Wrapper(),
      );
    },
  };
}

/// generated route for
/// [_i1.HomeWrapper]
class HomeWrapper extends _i17.PageRouteInfo<void> {
  const HomeWrapper({List<_i17.PageRouteInfo>? children})
      : super(
          HomeWrapper.name,
          initialChildren: children,
        );

  static const String name = 'HomeWrapper';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i2.InterestScreen]
class InterestRoute extends _i17.PageRouteInfo<InterestRouteArgs> {
  InterestRoute({
    _i18.Key? key,
    List<String>? initialValues,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          InterestRoute.name,
          args: InterestRouteArgs(
            key: key,
            initialValues: initialValues,
          ),
          initialChildren: children,
        );

  static const String name = 'InterestRoute';

  static const _i17.PageInfo<InterestRouteArgs> page =
      _i17.PageInfo<InterestRouteArgs>(name);
}

class InterestRouteArgs {
  const InterestRouteArgs({
    this.key,
    this.initialValues,
  });

  final _i18.Key? key;

  final List<String>? initialValues;

  @override
  String toString() {
    return 'InterestRouteArgs{key: $key, initialValues: $initialValues}';
  }
}

/// generated route for
/// [_i3.LoginScreen]
class LoginRoute extends _i17.PageRouteInfo<void> {
  const LoginRoute({List<_i17.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i4.PhoneNumberScreen]
class PhoneNumberRoute extends _i17.PageRouteInfo<PhoneNumberRouteArgs> {
  PhoneNumberRoute({
    _i18.Key? key,
    bool signIn = true,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          PhoneNumberRoute.name,
          args: PhoneNumberRouteArgs(
            key: key,
            signIn: signIn,
          ),
          initialChildren: children,
        );

  static const String name = 'PhoneNumberRoute';

  static const _i17.PageInfo<PhoneNumberRouteArgs> page =
      _i17.PageInfo<PhoneNumberRouteArgs>(name);
}

class PhoneNumberRouteArgs {
  const PhoneNumberRouteArgs({
    this.key,
    this.signIn = true,
  });

  final _i18.Key? key;

  final bool signIn;

  @override
  String toString() {
    return 'PhoneNumberRouteArgs{key: $key, signIn: $signIn}';
  }
}

/// generated route for
/// [_i5.PreferenceScreen]
class PreferenceRoute extends _i17.PageRouteInfo<void> {
  const PreferenceRoute({List<_i17.PageRouteInfo>? children})
      : super(
          PreferenceRoute.name,
          initialChildren: children,
        );

  static const String name = 'PreferenceRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i6.ResetPasswordScreen]
class ResetPasswordRoute extends _i17.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i17.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i7.ResetSuccessScreen]
class ResetSuccessRoute extends _i17.PageRouteInfo<ResetSuccessRouteArgs> {
  ResetSuccessRoute({
    _i18.Key? key,
    required String email,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          ResetSuccessRoute.name,
          args: ResetSuccessRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ResetSuccessRoute';

  static const _i17.PageInfo<ResetSuccessRouteArgs> page =
      _i17.PageInfo<ResetSuccessRouteArgs>(name);
}

class ResetSuccessRouteArgs {
  const ResetSuccessRouteArgs({
    this.key,
    required this.email,
  });

  final _i18.Key? key;

  final String email;

  @override
  String toString() {
    return 'ResetSuccessRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i8.SignUpCreateScreen]
class SignUpCreateRoute extends _i17.PageRouteInfo<void> {
  const SignUpCreateRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SignUpCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpCreateRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SignUpGenderScreen]
class SignUpGenderRoute extends _i17.PageRouteInfo<void> {
  const SignUpGenderRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SignUpGenderRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpGenderRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i10.SignUpNameScreen]
class SignUpNameRoute extends _i17.PageRouteInfo<void> {
  const SignUpNameRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SignUpNameRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpNameRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i11.SignUpPhoneScreen]
class SignUpPhoneRoute extends _i17.PageRouteInfo<void> {
  const SignUpPhoneRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SignUpPhoneRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpPhoneRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i12.SignUpVerificationScreen]
class SignUpVerificationRoute
    extends _i17.PageRouteInfo<SignUpVerificationRouteArgs> {
  SignUpVerificationRoute({
    _i18.Key? key,
    bool pop = false,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          SignUpVerificationRoute.name,
          args: SignUpVerificationRouteArgs(
            key: key,
            pop: pop,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpVerificationRoute';

  static const _i17.PageInfo<SignUpVerificationRouteArgs> page =
      _i17.PageInfo<SignUpVerificationRouteArgs>(name);
}

class SignUpVerificationRouteArgs {
  const SignUpVerificationRouteArgs({
    this.key,
    this.pop = false,
  });

  final _i18.Key? key;

  final bool pop;

  @override
  String toString() {
    return 'SignUpVerificationRouteArgs{key: $key, pop: $pop}';
  }
}

/// generated route for
/// [_i13.SplashScreen]
class SplashRoute extends _i17.PageRouteInfo<void> {
  const SplashRoute({List<_i17.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i14.VerificationCodeScreen]
class VerificationCodeRoute
    extends _i17.PageRouteInfo<VerificationCodeRouteArgs> {
  VerificationCodeRoute({
    _i18.Key? key,
    required String phone,
    required String verId,
    bool signIn = true,
    required int? resendToken,
    List<_i17.PageRouteInfo>? children,
  }) : super(
          VerificationCodeRoute.name,
          args: VerificationCodeRouteArgs(
            key: key,
            phone: phone,
            verId: verId,
            signIn: signIn,
            resendToken: resendToken,
          ),
          initialChildren: children,
        );

  static const String name = 'VerificationCodeRoute';

  static const _i17.PageInfo<VerificationCodeRouteArgs> page =
      _i17.PageInfo<VerificationCodeRouteArgs>(name);
}

class VerificationCodeRouteArgs {
  const VerificationCodeRouteArgs({
    this.key,
    required this.phone,
    required this.verId,
    this.signIn = true,
    required this.resendToken,
  });

  final _i18.Key? key;

  final String phone;

  final String verId;

  final bool signIn;

  final int? resendToken;

  @override
  String toString() {
    return 'VerificationCodeRouteArgs{key: $key, phone: $phone, verId: $verId, signIn: $signIn, resendToken: $resendToken}';
  }
}

/// generated route for
/// [_i15.WelcomeScreen]
class WelcomeRoute extends _i17.PageRouteInfo<void> {
  const WelcomeRoute({List<_i17.PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}

/// generated route for
/// [_i16.Wrapper]
class Wrapper extends _i17.PageRouteInfo<void> {
  const Wrapper({List<_i17.PageRouteInfo>? children})
      : super(
          Wrapper.name,
          initialChildren: children,
        );

  static const String name = 'Wrapper';

  static const _i17.PageInfo<void> page = _i17.PageInfo<void>(name);
}
