// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      uid: json['uid'] as String?,
      email: json['email'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      gender: json['gender'] as String?,
      phoneNumber: json['phone_number'] as String?,
      countryOfOrigin: json['country_of_origin'] as String?,
      authProvider:
          $enumDecodeNullable(_$AuthMethodEnumMap, json['auth_provider']),
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      hasCompletedAccountCreation:
          json['has_completed_account_creation'] as bool? ?? false,
      hasCompletedOnboarding:
          json['has_completed_onboarding'] as bool? ?? false,
      tokens:
          (json['tokens'] as List<dynamic>?)?.map((e) => e as String).toList(),
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: AppUtils.timestampFromJson(json['created_at']),
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('uid', instance.uid);
  writeNotNull('email', instance.email);
  writeNotNull('first_name', instance.firstName);
  writeNotNull('last_name', instance.lastName);
  writeNotNull('gender', instance.gender);
  writeNotNull('phone_number', instance.phoneNumber);
  writeNotNull('country_of_origin', instance.countryOfOrigin);
  writeNotNull('auth_provider', _$AuthMethodEnumMap[instance.authProvider]);
  writeNotNull('weight', instance.weight);
  writeNotNull('height', instance.height);
  val['has_completed_account_creation'] = instance.hasCompletedAccountCreation;
  val['has_completed_onboarding'] = instance.hasCompletedOnboarding;
  writeNotNull('tokens', instance.tokens);
  val['is_verified'] = instance.isVerified;
  writeNotNull('created_at', AppUtils.timestampToJson(instance.createdAt));
  return val;
}

const _$AuthMethodEnumMap = {
  AuthMethod.local: 'local',
  AuthMethod.google: 'google',
  AuthMethod.phone: 'phone',
};
