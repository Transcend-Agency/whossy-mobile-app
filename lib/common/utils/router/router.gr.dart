// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i30;
import 'package:flutter/material.dart' as _i31;
import 'package:whossy_app/feature/auth/login/view/login_screen.dart' as _i7;
import 'package:whossy_app/feature/auth/login/view/phone_number_screen.dart'
    as _i11;
import 'package:whossy_app/feature/auth/login/view/reset_screen.dart' as _i15;
import 'package:whossy_app/feature/auth/login/view/reset_success_screen.dart'
    as _i16;
import 'package:whossy_app/feature/auth/login/view/verification_code_screen.dart'
    as _i27;
import 'package:whossy_app/feature/auth/onboarding/view/wrapper.dart' as _i29;
import 'package:whossy_app/feature/auth/sign_up/view/create.dart' as _i19;
import 'package:whossy_app/feature/auth/sign_up/view/gender.dart' as _i20;
import 'package:whossy_app/feature/auth/sign_up/view/name.dart' as _i21;
import 'package:whossy_app/feature/auth/sign_up/view/phone.dart' as _i22;
import 'package:whossy_app/feature/auth/sign_up/view/verification.dart' as _i23;
import 'package:whossy_app/feature/auth/sign_up/view/welcome.dart' as _i28;
import 'package:whossy_app/feature/home/edit_profile/model/core_profile.dart'
    as _i32;
import 'package:whossy_app/feature/home/edit_profile/view/edit_profile.dart'
    as _i3;
import 'package:whossy_app/feature/home/edit_profile/view/preview_profile.dart'
    as _i13;
import 'package:whossy_app/feature/home/edit_profile/view/preview_profile_more.dart'
    as _i14;
import 'package:whossy_app/feature/home/edit_profile/view/widgets/edit/name_edit_profile.dart'
    as _i10;
import 'package:whossy_app/feature/home/home_wrapper.dart' as _i4;
import 'package:whossy_app/feature/home/preferences/model/core_preferences.dart'
    as _i33;
import 'package:whossy_app/feature/home/preferences/view/interest_screen.dart'
    as _i6;
import 'package:whossy_app/feature/home/preferences/view/preference_screen.dart'
    as _i12;
import 'package:whossy_app/feature/home/settings/view/settings.dart' as _i18;
import 'package:whossy_app/feature/home/tabs/chat/view/chat_room/chat_room.dart'
    as _i2;
import 'package:whossy_app/feature/home/tabs/chat/view/image_preview.dart'
    as _i5;
import 'package:whossy_app/feature/home/tabs/explore/view/advanced_search_screen.dart'
    as _i1;
import 'package:whossy_app/feature/home/tabs/explore/view/matching_screen.dart'
    as _i8;
import 'package:whossy_app/feature/home/tabs/likes_and_match/view/widgets/more_info.dart'
    as _i9;
import 'package:whossy_app/feature/home/tabs/profile/view/safety_guide.dart'
    as _i17;
import 'package:whossy_app/feature/home/tabs/profile/view/subscription_plans.dart'
    as _i26;
import 'package:whossy_app/feature/splash/splash.dart' as _i24;
import 'package:whossy_app/feature/splash/splash_screen.dart' as _i25;

/// generated route for
/// [_i1.AdvancedSearchScreen]
class AdvancedSearchRoute extends _i30.PageRouteInfo<void> {
  const AdvancedSearchRoute({List<_i30.PageRouteInfo>? children})
      : super(
          AdvancedSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdvancedSearchRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i1.AdvancedSearchScreen();
    },
  );
}

/// generated route for
/// [_i2.ChatRoom]
class ChatRoom extends _i30.PageRouteInfo<void> {
  const ChatRoom({List<_i30.PageRouteInfo>? children})
      : super(
          ChatRoom.name,
          initialChildren: children,
        );

  static const String name = 'ChatRoom';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i2.ChatRoom();
    },
  );
}

/// generated route for
/// [_i3.EditProfile]
class EditProfile extends _i30.PageRouteInfo<void> {
  const EditProfile({List<_i30.PageRouteInfo>? children})
      : super(
          EditProfile.name,
          initialChildren: children,
        );

  static const String name = 'EditProfile';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i3.EditProfile();
    },
  );
}

/// generated route for
/// [_i4.HomeWrapper]
class HomeWrapper extends _i30.PageRouteInfo<void> {
  const HomeWrapper({List<_i30.PageRouteInfo>? children})
      : super(
          HomeWrapper.name,
          initialChildren: children,
        );

  static const String name = 'HomeWrapper';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i4.HomeWrapper();
    },
  );
}

/// generated route for
/// [_i5.ImagePreview]
class ImagePreview extends _i30.PageRouteInfo<void> {
  const ImagePreview({List<_i30.PageRouteInfo>? children})
      : super(
          ImagePreview.name,
          initialChildren: children,
        );

  static const String name = 'ImagePreview';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i5.ImagePreview();
    },
  );
}

/// generated route for
/// [_i6.InterestScreen]
class InterestRoute extends _i30.PageRouteInfo<InterestRouteArgs> {
  InterestRoute({
    _i31.Key? key,
    List<String>? initialValues,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          InterestRoute.name,
          args: InterestRouteArgs(
            key: key,
            initialValues: initialValues,
          ),
          initialChildren: children,
        );

  static const String name = 'InterestRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InterestRouteArgs>(
          orElse: () => const InterestRouteArgs());
      return _i6.InterestScreen(
        key: args.key,
        initialValues: args.initialValues,
      );
    },
  );
}

class InterestRouteArgs {
  const InterestRouteArgs({
    this.key,
    this.initialValues,
  });

  final _i31.Key? key;

  final List<String>? initialValues;

  @override
  String toString() {
    return 'InterestRouteArgs{key: $key, initialValues: $initialValues}';
  }
}

/// generated route for
/// [_i7.LoginScreen]
class LoginRoute extends _i30.PageRouteInfo<void> {
  const LoginRoute({List<_i30.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i7.LoginScreen();
    },
  );
}

/// generated route for
/// [_i8.MatchingScreen]
class MatchingRoute extends _i30.PageRouteInfo<MatchingRouteArgs> {
  MatchingRoute({
    _i31.Key? key,
    required _i32.CoreProfile profile,
    required _i33.CorePreferences preferences,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          MatchingRoute.name,
          args: MatchingRouteArgs(
            key: key,
            profile: profile,
            preferences: preferences,
          ),
          initialChildren: children,
        );

  static const String name = 'MatchingRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MatchingRouteArgs>();
      return _i8.MatchingScreen(
        key: args.key,
        profile: args.profile,
        preferences: args.preferences,
      );
    },
  );
}

class MatchingRouteArgs {
  const MatchingRouteArgs({
    this.key,
    required this.profile,
    required this.preferences,
  });

  final _i31.Key? key;

  final _i32.CoreProfile profile;

  final _i33.CorePreferences preferences;

  @override
  String toString() {
    return 'MatchingRouteArgs{key: $key, profile: $profile, preferences: $preferences}';
  }
}

/// generated route for
/// [_i9.MoreInfoScreen]
class MoreInfoRoute extends _i30.PageRouteInfo<void> {
  const MoreInfoRoute({List<_i30.PageRouteInfo>? children})
      : super(
          MoreInfoRoute.name,
          initialChildren: children,
        );

  static const String name = 'MoreInfoRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i9.MoreInfoScreen();
    },
  );
}

/// generated route for
/// [_i10.NameEditProfile]
class NameEditProfile extends _i30.PageRouteInfo<void> {
  const NameEditProfile({List<_i30.PageRouteInfo>? children})
      : super(
          NameEditProfile.name,
          initialChildren: children,
        );

  static const String name = 'NameEditProfile';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i10.NameEditProfile();
    },
  );
}

/// generated route for
/// [_i11.PhoneNumberScreen]
class PhoneNumberRoute extends _i30.PageRouteInfo<PhoneNumberRouteArgs> {
  PhoneNumberRoute({
    _i31.Key? key,
    bool signIn = true,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          PhoneNumberRoute.name,
          args: PhoneNumberRouteArgs(
            key: key,
            signIn: signIn,
          ),
          initialChildren: children,
        );

  static const String name = 'PhoneNumberRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PhoneNumberRouteArgs>(
          orElse: () => const PhoneNumberRouteArgs());
      return _i11.PhoneNumberScreen(
        key: args.key,
        signIn: args.signIn,
      );
    },
  );
}

class PhoneNumberRouteArgs {
  const PhoneNumberRouteArgs({
    this.key,
    this.signIn = true,
  });

  final _i31.Key? key;

  final bool signIn;

  @override
  String toString() {
    return 'PhoneNumberRouteArgs{key: $key, signIn: $signIn}';
  }
}

/// generated route for
/// [_i12.PreferenceScreen]
class PreferenceRoute extends _i30.PageRouteInfo<void> {
  const PreferenceRoute({List<_i30.PageRouteInfo>? children})
      : super(
          PreferenceRoute.name,
          initialChildren: children,
        );

  static const String name = 'PreferenceRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i12.PreferenceScreen();
    },
  );
}

/// generated route for
/// [_i13.PreviewProfile]
class PreviewProfile extends _i30.PageRouteInfo<void> {
  const PreviewProfile({List<_i30.PageRouteInfo>? children})
      : super(
          PreviewProfile.name,
          initialChildren: children,
        );

  static const String name = 'PreviewProfile';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i13.PreviewProfile();
    },
  );
}

/// generated route for
/// [_i14.PreviewProfileMore]
class PreviewProfileMore extends _i30.PageRouteInfo<PreviewProfileMoreArgs> {
  PreviewProfileMore({
    _i31.Key? key,
    required int index,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          PreviewProfileMore.name,
          args: PreviewProfileMoreArgs(
            key: key,
            index: index,
          ),
          initialChildren: children,
        );

  static const String name = 'PreviewProfileMore';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PreviewProfileMoreArgs>();
      return _i14.PreviewProfileMore(
        key: args.key,
        index: args.index,
      );
    },
  );
}

class PreviewProfileMoreArgs {
  const PreviewProfileMoreArgs({
    this.key,
    required this.index,
  });

  final _i31.Key? key;

  final int index;

  @override
  String toString() {
    return 'PreviewProfileMoreArgs{key: $key, index: $index}';
  }
}

/// generated route for
/// [_i15.ResetPasswordScreen]
class ResetPasswordRoute extends _i30.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i30.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i15.ResetPasswordScreen();
    },
  );
}

/// generated route for
/// [_i16.ResetSuccessScreen]
class ResetSuccessRoute extends _i30.PageRouteInfo<ResetSuccessRouteArgs> {
  ResetSuccessRoute({
    _i31.Key? key,
    required String email,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          ResetSuccessRoute.name,
          args: ResetSuccessRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ResetSuccessRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResetSuccessRouteArgs>();
      return _i16.ResetSuccessScreen(
        key: args.key,
        email: args.email,
      );
    },
  );
}

class ResetSuccessRouteArgs {
  const ResetSuccessRouteArgs({
    this.key,
    required this.email,
  });

  final _i31.Key? key;

  final String email;

  @override
  String toString() {
    return 'ResetSuccessRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i17.SafetyGuide]
class SafetyGuide extends _i30.PageRouteInfo<void> {
  const SafetyGuide({List<_i30.PageRouteInfo>? children})
      : super(
          SafetyGuide.name,
          initialChildren: children,
        );

  static const String name = 'SafetyGuide';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i17.SafetyGuide();
    },
  );
}

/// generated route for
/// [_i18.Settings]
class Settings extends _i30.PageRouteInfo<void> {
  const Settings({List<_i30.PageRouteInfo>? children})
      : super(
          Settings.name,
          initialChildren: children,
        );

  static const String name = 'Settings';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i18.Settings();
    },
  );
}

/// generated route for
/// [_i19.SignUpCreateScreen]
class SignUpCreateRoute extends _i30.PageRouteInfo<void> {
  const SignUpCreateRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SignUpCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpCreateRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i19.SignUpCreateScreen();
    },
  );
}

/// generated route for
/// [_i20.SignUpGenderScreen]
class SignUpGenderRoute extends _i30.PageRouteInfo<void> {
  const SignUpGenderRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SignUpGenderRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpGenderRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i20.SignUpGenderScreen();
    },
  );
}

/// generated route for
/// [_i21.SignUpNameScreen]
class SignUpNameRoute extends _i30.PageRouteInfo<void> {
  const SignUpNameRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SignUpNameRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpNameRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i21.SignUpNameScreen();
    },
  );
}

/// generated route for
/// [_i22.SignUpPhoneScreen]
class SignUpPhoneRoute extends _i30.PageRouteInfo<void> {
  const SignUpPhoneRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SignUpPhoneRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpPhoneRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i22.SignUpPhoneScreen();
    },
  );
}

/// generated route for
/// [_i23.SignUpVerificationScreen]
class SignUpVerificationRoute
    extends _i30.PageRouteInfo<SignUpVerificationRouteArgs> {
  SignUpVerificationRoute({
    _i31.Key? key,
    bool pop = false,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          SignUpVerificationRoute.name,
          args: SignUpVerificationRouteArgs(
            key: key,
            pop: pop,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpVerificationRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpVerificationRouteArgs>(
          orElse: () => const SignUpVerificationRouteArgs());
      return _i23.SignUpVerificationScreen(
        key: args.key,
        pop: args.pop,
      );
    },
  );
}

class SignUpVerificationRouteArgs {
  const SignUpVerificationRouteArgs({
    this.key,
    this.pop = false,
  });

  final _i31.Key? key;

  final bool pop;

  @override
  String toString() {
    return 'SignUpVerificationRouteArgs{key: $key, pop: $pop}';
  }
}

/// generated route for
/// [_i24.Splash]
class Splash extends _i30.PageRouteInfo<void> {
  const Splash({List<_i30.PageRouteInfo>? children})
      : super(
          Splash.name,
          initialChildren: children,
        );

  static const String name = 'Splash';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i24.Splash();
    },
  );
}

/// generated route for
/// [_i25.SplashScreen]
class SplashRoute extends _i30.PageRouteInfo<void> {
  const SplashRoute({List<_i30.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i25.SplashScreen();
    },
  );
}

/// generated route for
/// [_i26.SubscriptionPlans]
class SubscriptionPlans extends _i30.PageRouteInfo<SubscriptionPlansArgs> {
  SubscriptionPlans({
    _i31.Key? key,
    required int initialPage,
    List<_i30.PageRouteInfo>? children,
  }) : super(
          SubscriptionPlans.name,
          args: SubscriptionPlansArgs(
            key: key,
            initialPage: initialPage,
          ),
          initialChildren: children,
        );

  static const String name = 'SubscriptionPlans';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SubscriptionPlansArgs>();
      return _i26.SubscriptionPlans(
        key: args.key,
        initialPage: args.initialPage,
      );
    },
  );
}

class SubscriptionPlansArgs {
  const SubscriptionPlansArgs({
    this.key,
    required this.initialPage,
  });

  final _i31.Key? key;

  final int initialPage;

  @override
  String toString() {
    return 'SubscriptionPlansArgs{key: $key, initialPage: $initialPage}';
  }
}

/// generated route for
/// [_i27.VerificationCodeScreen]
class VerificationCodeRoute
    extends _i30.PageRouteInfo<VerificationCodeRouteArgs> {
  VerificationCodeRoute({
    _i31.Key? key,
    required String phone,
    required String verId,
    bool signIn = true,
    required int? resendToken,
    List<_i30.PageRouteInfo>? children,
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

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerificationCodeRouteArgs>();
      return _i27.VerificationCodeScreen(
        key: args.key,
        phone: args.phone,
        verId: args.verId,
        signIn: args.signIn,
        resendToken: args.resendToken,
      );
    },
  );
}

class VerificationCodeRouteArgs {
  const VerificationCodeRouteArgs({
    this.key,
    required this.phone,
    required this.verId,
    this.signIn = true,
    required this.resendToken,
  });

  final _i31.Key? key;

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
/// [_i28.WelcomeScreen]
class WelcomeRoute extends _i30.PageRouteInfo<void> {
  const WelcomeRoute({List<_i30.PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i28.WelcomeScreen();
    },
  );
}

/// generated route for
/// [_i29.Wrapper]
class Wrapper extends _i30.PageRouteInfo<void> {
  const Wrapper({List<_i30.PageRouteInfo>? children})
      : super(
          Wrapper.name,
          initialChildren: children,
        );

  static const String name = 'Wrapper';

  static _i30.PageInfo page = _i30.PageInfo(
    name,
    builder: (data) {
      return const _i29.Wrapper();
    },
  );
}
