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
      hasCompletedAccountCreation:
          json['has_completed_account_creation'] as bool? ?? false,
      hasCompletedAccountOnboarding:
          json['has_completed_account_onboarding'] as bool? ?? false,
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'gender': instance.gender,
      'phone_number': instance.phoneNumber,
      'country_of_origin': instance.countryOfOrigin,
      'authProvider': instance.authProvider,
      'has_completed_account_creation': instance.hasCompletedAccountCreation,
      'has_completed_account_onboarding':
          instance.hasCompletedAccountOnboarding,
    };
