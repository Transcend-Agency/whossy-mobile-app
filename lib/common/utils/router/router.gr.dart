// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i32;
import 'package:flutter/material.dart' as _i33;
import 'package:image_picker/image_picker.dart' as _i34;
import 'package:whossy_app/feature/auth/login/view/login_screen.dart' as _i10;
import 'package:whossy_app/feature/auth/login/view/phone_number_screen.dart'
    as _i14;
import 'package:whossy_app/feature/auth/login/view/reset_screen.dart' as _i17;
import 'package:whossy_app/feature/auth/login/view/reset_success_screen.dart'
    as _i18;
import 'package:whossy_app/feature/auth/login/view/verification_code_screen.dart'
    as _i29;
import 'package:whossy_app/feature/auth/onboarding/view/wrapper.dart' as _i31;
import 'package:whossy_app/feature/auth/sign_up/view/create.dart' as _i21;
import 'package:whossy_app/feature/auth/sign_up/view/gender.dart' as _i22;
import 'package:whossy_app/feature/auth/sign_up/view/name.dart' as _i23;
import 'package:whossy_app/feature/auth/sign_up/view/phone.dart' as _i24;
import 'package:whossy_app/feature/auth/sign_up/view/verification.dart' as _i25;
import 'package:whossy_app/feature/auth/sign_up/view/welcome.dart' as _i30;
import 'package:whossy_app/feature/home/edit_profile/view/edit_profile.dart'
    as _i5;
import 'package:whossy_app/feature/home/edit_profile/view/edit_profile_preview.dart'
    as _i6;
import 'package:whossy_app/feature/home/edit_profile/view/preview_profile.dart'
    as _i16;
import 'package:whossy_app/feature/home/edit_profile/view/widgets/edit/name_edit_profile.dart'
    as _i12;
import 'package:whossy_app/feature/home/home_wrapper.dart' as _i7;
import 'package:whossy_app/feature/home/notifications/view/notification_screen.dart'
    as _i13;
import 'package:whossy_app/feature/home/preferences/view/interest_screen.dart'
    as _i9;
import 'package:whossy_app/feature/home/preferences/view/preference_screen.dart'
    as _i15;
import 'package:whossy_app/feature/home/settings/view/blocked_contacts/blocked_contacts.dart'
    as _i2;
import 'package:whossy_app/feature/home/settings/view/settings.dart' as _i20;
import 'package:whossy_app/feature/home/tabs/chat/view/chat_room/chat_room.dart'
    as _i3;
import 'package:whossy_app/feature/home/tabs/chat/view/image_preview/image_preview.dart'
    as _i8;
import 'package:whossy_app/feature/home/tabs/explore/view/advanced_search_screen.dart'
    as _i1;
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart'
    as _i35;
import 'package:whossy_app/feature/home/tabs/matching/view/widgets/matching_profile_preview.dart'
    as _i11;
import 'package:whossy_app/feature/home/tabs/profile/view/credits.dart' as _i4;
import 'package:whossy_app/feature/home/tabs/profile/view/safety_guide.dart'
    as _i19;
import 'package:whossy_app/feature/home/tabs/profile/view/subscription_plans.dart'
    as _i28;
import 'package:whossy_app/feature/splash/splash.dart' as _i26;
import 'package:whossy_app/feature/splash/splash_screen.dart' as _i27;

/// generated route for
/// [_i1.AdvancedSearchScreen]
class AdvancedSearchRoute extends _i32.PageRouteInfo<void> {
  const AdvancedSearchRoute({List<_i32.PageRouteInfo>? children})
      : super(
          AdvancedSearchRoute.name,
          initialChildren: children,
        );

  static const String name = 'AdvancedSearchRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i1.AdvancedSearchScreen();
    },
  );
}

/// generated route for
/// [_i2.BlockedContacts]
class BlockedContacts extends _i32.PageRouteInfo<BlockedContactsArgs> {
  BlockedContacts({
    _i33.Key? key,
    required List<String> uids,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          BlockedContacts.name,
          args: BlockedContactsArgs(
            key: key,
            uids: uids,
          ),
          initialChildren: children,
        );

  static const String name = 'BlockedContacts';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BlockedContactsArgs>();
      return _i2.BlockedContacts(
        key: args.key,
        uids: args.uids,
      );
    },
  );
}

class BlockedContactsArgs {
  const BlockedContactsArgs({
    this.key,
    required this.uids,
  });

  final _i33.Key? key;

  final List<String> uids;

  @override
  String toString() {
    return 'BlockedContactsArgs{key: $key, uids: $uids}';
  }
}

/// generated route for
/// [_i3.ChatRoom]
class ChatRoom extends _i32.PageRouteInfo<void> {
  const ChatRoom({List<_i32.PageRouteInfo>? children})
      : super(
          ChatRoom.name,
          initialChildren: children,
        );

  static const String name = 'ChatRoom';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i3.ChatRoom();
    },
  );
}

/// generated route for
/// [_i4.Credits]
class Credits extends _i32.PageRouteInfo<void> {
  const Credits({List<_i32.PageRouteInfo>? children})
      : super(
          Credits.name,
          initialChildren: children,
        );

  static const String name = 'Credits';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i4.Credits();
    },
  );
}

/// generated route for
/// [_i5.EditProfile]
class EditProfile extends _i32.PageRouteInfo<void> {
  const EditProfile({List<_i32.PageRouteInfo>? children})
      : super(
          EditProfile.name,
          initialChildren: children,
        );

  static const String name = 'EditProfile';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i5.EditProfile();
    },
  );
}

/// generated route for
/// [_i6.EditProfilePreview]
class EditProfilePreview extends _i32.PageRouteInfo<EditProfilePreviewArgs> {
  EditProfilePreview({
    _i33.Key? key,
    required int index,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          EditProfilePreview.name,
          args: EditProfilePreviewArgs(
            key: key,
            index: index,
          ),
          initialChildren: children,
        );

  static const String name = 'EditProfilePreview';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditProfilePreviewArgs>();
      return _i6.EditProfilePreview(
        key: args.key,
        index: args.index,
      );
    },
  );
}

class EditProfilePreviewArgs {
  const EditProfilePreviewArgs({
    this.key,
    required this.index,
  });

  final _i33.Key? key;

  final int index;

  @override
  String toString() {
    return 'EditProfilePreviewArgs{key: $key, index: $index}';
  }
}

/// generated route for
/// [_i7.HomeWrapper]
class HomeWrapper extends _i32.PageRouteInfo<void> {
  const HomeWrapper({List<_i32.PageRouteInfo>? children})
      : super(
          HomeWrapper.name,
          initialChildren: children,
        );

  static const String name = 'HomeWrapper';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i7.HomeWrapper();
    },
  );
}

/// generated route for
/// [_i8.ImagePreview]
class ImagePreview extends _i32.PageRouteInfo<ImagePreviewArgs> {
  ImagePreview({
    _i33.Key? key,
    required List<_i34.XFile> images,
    required String? text,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          ImagePreview.name,
          args: ImagePreviewArgs(
            key: key,
            images: images,
            text: text,
          ),
          initialChildren: children,
        );

  static const String name = 'ImagePreview';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ImagePreviewArgs>();
      return _i8.ImagePreview(
        key: args.key,
        images: args.images,
        text: args.text,
      );
    },
  );
}

class ImagePreviewArgs {
  const ImagePreviewArgs({
    this.key,
    required this.images,
    required this.text,
  });

  final _i33.Key? key;

  final List<_i34.XFile> images;

  final String? text;

  @override
  String toString() {
    return 'ImagePreviewArgs{key: $key, images: $images, text: $text}';
  }
}

/// generated route for
/// [_i9.InterestScreen]
class InterestRoute extends _i32.PageRouteInfo<InterestRouteArgs> {
  InterestRoute({
    _i33.Key? key,
    List<String>? initialValues,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          InterestRoute.name,
          args: InterestRouteArgs(
            key: key,
            initialValues: initialValues,
          ),
          initialChildren: children,
        );

  static const String name = 'InterestRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<InterestRouteArgs>(
          orElse: () => const InterestRouteArgs());
      return _i9.InterestScreen(
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

  final _i33.Key? key;

  final List<String>? initialValues;

  @override
  String toString() {
    return 'InterestRouteArgs{key: $key, initialValues: $initialValues}';
  }
}

/// generated route for
/// [_i10.LoginScreen]
class LoginRoute extends _i32.PageRouteInfo<void> {
  const LoginRoute({List<_i32.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i10.LoginScreen();
    },
  );
}

/// generated route for
/// [_i11.MatchingProfilePreview]
class MatchingProfilePreview
    extends _i32.PageRouteInfo<MatchingProfilePreviewArgs> {
  MatchingProfilePreview({
    _i33.Key? key,
    required int index,
    required _i35.UserProfile userProfile,
    String? pageName,
    bool showMessaging = false,
    bool useDefaultTag = false,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          MatchingProfilePreview.name,
          args: MatchingProfilePreviewArgs(
            key: key,
            index: index,
            userProfile: userProfile,
            pageName: pageName,
            showMessaging: showMessaging,
            useDefaultTag: useDefaultTag,
          ),
          initialChildren: children,
        );

  static const String name = 'MatchingProfilePreview';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MatchingProfilePreviewArgs>();
      return _i11.MatchingProfilePreview(
        key: args.key,
        index: args.index,
        userProfile: args.userProfile,
        pageName: args.pageName,
        showMessaging: args.showMessaging,
        useDefaultTag: args.useDefaultTag,
      );
    },
  );
}

class MatchingProfilePreviewArgs {
  const MatchingProfilePreviewArgs({
    this.key,
    required this.index,
    required this.userProfile,
    this.pageName,
    this.showMessaging = false,
    this.useDefaultTag = false,
  });

  final _i33.Key? key;

  final int index;

  final _i35.UserProfile userProfile;

  final String? pageName;

  final bool showMessaging;

  final bool useDefaultTag;

  @override
  String toString() {
    return 'MatchingProfilePreviewArgs{key: $key, index: $index, userProfile: $userProfile, pageName: $pageName, showMessaging: $showMessaging, useDefaultTag: $useDefaultTag}';
  }
}

/// generated route for
/// [_i12.NameEditProfile]
class NameEditProfile extends _i32.PageRouteInfo<void> {
  const NameEditProfile({List<_i32.PageRouteInfo>? children})
      : super(
          NameEditProfile.name,
          initialChildren: children,
        );

  static const String name = 'NameEditProfile';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i12.NameEditProfile();
    },
  );
}

/// generated route for
/// [_i13.NotificationScreen]
class NotificationRoute extends _i32.PageRouteInfo<void> {
  const NotificationRoute({List<_i32.PageRouteInfo>? children})
      : super(
          NotificationRoute.name,
          initialChildren: children,
        );

  static const String name = 'NotificationRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i13.NotificationScreen();
    },
  );
}

/// generated route for
/// [_i14.PhoneNumberScreen]
class PhoneNumberRoute extends _i32.PageRouteInfo<PhoneNumberRouteArgs> {
  PhoneNumberRoute({
    _i33.Key? key,
    bool signIn = true,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          PhoneNumberRoute.name,
          args: PhoneNumberRouteArgs(
            key: key,
            signIn: signIn,
          ),
          initialChildren: children,
        );

  static const String name = 'PhoneNumberRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PhoneNumberRouteArgs>(
          orElse: () => const PhoneNumberRouteArgs());
      return _i14.PhoneNumberScreen(
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

  final _i33.Key? key;

  final bool signIn;

  @override
  String toString() {
    return 'PhoneNumberRouteArgs{key: $key, signIn: $signIn}';
  }
}

/// generated route for
/// [_i15.PreferenceScreen]
class PreferenceRoute extends _i32.PageRouteInfo<void> {
  const PreferenceRoute({List<_i32.PageRouteInfo>? children})
      : super(
          PreferenceRoute.name,
          initialChildren: children,
        );

  static const String name = 'PreferenceRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i15.PreferenceScreen();
    },
  );
}

/// generated route for
/// [_i16.PreviewProfile]
class PreviewProfile extends _i32.PageRouteInfo<void> {
  const PreviewProfile({List<_i32.PageRouteInfo>? children})
      : super(
          PreviewProfile.name,
          initialChildren: children,
        );

  static const String name = 'PreviewProfile';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i16.PreviewProfile();
    },
  );
}

/// generated route for
/// [_i17.ResetPasswordScreen]
class ResetPasswordRoute extends _i32.PageRouteInfo<void> {
  const ResetPasswordRoute({List<_i32.PageRouteInfo>? children})
      : super(
          ResetPasswordRoute.name,
          initialChildren: children,
        );

  static const String name = 'ResetPasswordRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i17.ResetPasswordScreen();
    },
  );
}

/// generated route for
/// [_i18.ResetSuccessScreen]
class ResetSuccessRoute extends _i32.PageRouteInfo<ResetSuccessRouteArgs> {
  ResetSuccessRoute({
    _i33.Key? key,
    required String email,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          ResetSuccessRoute.name,
          args: ResetSuccessRouteArgs(
            key: key,
            email: email,
          ),
          initialChildren: children,
        );

  static const String name = 'ResetSuccessRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ResetSuccessRouteArgs>();
      return _i18.ResetSuccessScreen(
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

  final _i33.Key? key;

  final String email;

  @override
  String toString() {
    return 'ResetSuccessRouteArgs{key: $key, email: $email}';
  }
}

/// generated route for
/// [_i19.SafetyGuide]
class SafetyGuide extends _i32.PageRouteInfo<void> {
  const SafetyGuide({List<_i32.PageRouteInfo>? children})
      : super(
          SafetyGuide.name,
          initialChildren: children,
        );

  static const String name = 'SafetyGuide';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i19.SafetyGuide();
    },
  );
}

/// generated route for
/// [_i20.Settings]
class Settings extends _i32.PageRouteInfo<void> {
  const Settings({List<_i32.PageRouteInfo>? children})
      : super(
          Settings.name,
          initialChildren: children,
        );

  static const String name = 'Settings';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i20.Settings();
    },
  );
}

/// generated route for
/// [_i21.SignUpCreateScreen]
class SignUpCreateRoute extends _i32.PageRouteInfo<void> {
  const SignUpCreateRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SignUpCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpCreateRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i21.SignUpCreateScreen();
    },
  );
}

/// generated route for
/// [_i22.SignUpGenderScreen]
class SignUpGenderRoute extends _i32.PageRouteInfo<void> {
  const SignUpGenderRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SignUpGenderRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpGenderRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i22.SignUpGenderScreen();
    },
  );
}

/// generated route for
/// [_i23.SignUpNameScreen]
class SignUpNameRoute extends _i32.PageRouteInfo<void> {
  const SignUpNameRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SignUpNameRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpNameRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i23.SignUpNameScreen();
    },
  );
}

/// generated route for
/// [_i24.SignUpPhoneScreen]
class SignUpPhoneRoute extends _i32.PageRouteInfo<void> {
  const SignUpPhoneRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SignUpPhoneRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpPhoneRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i24.SignUpPhoneScreen();
    },
  );
}

/// generated route for
/// [_i25.SignUpVerificationScreen]
class SignUpVerificationRoute
    extends _i32.PageRouteInfo<SignUpVerificationRouteArgs> {
  SignUpVerificationRoute({
    _i33.Key? key,
    bool pop = false,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          SignUpVerificationRoute.name,
          args: SignUpVerificationRouteArgs(
            key: key,
            pop: pop,
          ),
          initialChildren: children,
        );

  static const String name = 'SignUpVerificationRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SignUpVerificationRouteArgs>(
          orElse: () => const SignUpVerificationRouteArgs());
      return _i25.SignUpVerificationScreen(
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

  final _i33.Key? key;

  final bool pop;

  @override
  String toString() {
    return 'SignUpVerificationRouteArgs{key: $key, pop: $pop}';
  }
}

/// generated route for
/// [_i26.Splash]
class Splash extends _i32.PageRouteInfo<void> {
  const Splash({List<_i32.PageRouteInfo>? children})
      : super(
          Splash.name,
          initialChildren: children,
        );

  static const String name = 'Splash';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i26.Splash();
    },
  );
}

/// generated route for
/// [_i27.SplashScreen]
class SplashRoute extends _i32.PageRouteInfo<void> {
  const SplashRoute({List<_i32.PageRouteInfo>? children})
      : super(
          SplashRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i27.SplashScreen();
    },
  );
}

/// generated route for
/// [_i28.SubscriptionPlans]
class SubscriptionPlans extends _i32.PageRouteInfo<SubscriptionPlansArgs> {
  SubscriptionPlans({
    _i33.Key? key,
    required int initialPage,
    List<_i32.PageRouteInfo>? children,
  }) : super(
          SubscriptionPlans.name,
          args: SubscriptionPlansArgs(
            key: key,
            initialPage: initialPage,
          ),
          initialChildren: children,
        );

  static const String name = 'SubscriptionPlans';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SubscriptionPlansArgs>();
      return _i28.SubscriptionPlans(
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

  final _i33.Key? key;

  final int initialPage;

  @override
  String toString() {
    return 'SubscriptionPlansArgs{key: $key, initialPage: $initialPage}';
  }
}

/// generated route for
/// [_i29.VerificationCodeScreen]
class VerificationCodeRoute
    extends _i32.PageRouteInfo<VerificationCodeRouteArgs> {
  VerificationCodeRoute({
    _i33.Key? key,
    required String phone,
    required String verId,
    bool signIn = true,
    required int? resendToken,
    List<_i32.PageRouteInfo>? children,
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

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<VerificationCodeRouteArgs>();
      return _i29.VerificationCodeScreen(
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

  final _i33.Key? key;

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
/// [_i30.WelcomeScreen]
class WelcomeRoute extends _i32.PageRouteInfo<void> {
  const WelcomeRoute({List<_i32.PageRouteInfo>? children})
      : super(
          WelcomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'WelcomeRoute';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i30.WelcomeScreen();
    },
  );
}

/// generated route for
/// [_i31.Wrapper]
class Wrapper extends _i32.PageRouteInfo<void> {
  const Wrapper({List<_i32.PageRouteInfo>? children})
      : super(
          Wrapper.name,
          initialChildren: children,
        );

  static const String name = 'Wrapper';

  static _i32.PageInfo page = _i32.PageInfo(
    name,
    builder: (data) {
      return const _i31.Wrapper();
    },
  );
}
