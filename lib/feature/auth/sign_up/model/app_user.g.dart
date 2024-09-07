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
      authProvider: json['authProvider'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      hasCompletedAccountCreation:
          json['has_completed_account_creation'] as bool? ?? false,
      hasCompletedOnboarding:
          json['has_completed_onboarding'] as bool? ?? false,
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
  writeNotNull('authProvider', instance.authProvider);
  writeNotNull('weight', instance.weight);
  writeNotNull('height', instance.height);
  val['has_completed_account_creation'] = instance.hasCompletedAccountCreation;
  val['has_completed_onboarding'] = instance.hasCompletedOnboarding;
  return val;
}
