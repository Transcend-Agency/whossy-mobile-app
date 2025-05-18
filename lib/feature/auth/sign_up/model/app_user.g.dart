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
      isApproved: json['is_approved'] as bool? ?? false,
      isBanned: json['is_banned'] as bool? ?? false,
      createdAt: TimestampWrapper.timestampFromJson(json['created_at']),
      status: json['status'] == null
          ? null
          : UserStatus.fromJson(json['status'] as Map<String, dynamic>),
      userSettings: AppUtils.userSettingsFromJson(
          json['user_settings'] as Map<String, dynamic>?),
      isPremium: json['is_premium'] as bool? ?? false,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      location: AppUtils.geoPointFromJson(json['location']),
      geohash: json['geohash'] as String?,
      geography: AppUtils.geographyFromJson(
          json['geography'] as Map<String, dynamic>?),
      creditBalance: (json['credit_balance'] as num?)?.toInt() ?? 0,
      currentPlan: (json['current_plan'] as num?)?.toInt(),
      paystackUser: PaystackUser.paystackUserFromJson(
          json['paystack'] as Map<String, dynamic>?),
      amountPaid: AppUtils.paymentFromJson(
          json['amount_paid_in_total'] as Map<String, dynamic>?),
      blockedIds: (json['blockedIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      faceVerification: FaceVerification.faceVerificationFromJson(
          json['face_verification'] as Map<String, dynamic>?),
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      if (instance.uid case final value?) 'uid': value,
      if (instance.email case final value?) 'email': value,
      if (instance.firstName case final value?) 'first_name': value,
      if (instance.lastName case final value?) 'last_name': value,
      if (instance.gender case final value?) 'gender': value,
      if (instance.phoneNumber case final value?) 'phone_number': value,
      if (instance.countryOfOrigin case final value?)
        'country_of_origin': value,
      if (_$AuthMethodEnumMap[instance.authProvider] case final value?)
        'auth_provider': value,
      if (instance.weight case final value?) 'weight': value,
      if (instance.height case final value?) 'height': value,
      'has_completed_account_creation': instance.hasCompletedAccountCreation,
      'has_completed_onboarding': instance.hasCompletedOnboarding,
      if (instance.tokens case final value?) 'tokens': value,
      'is_approved': instance.isApproved,
      'is_banned': instance.isBanned,
      if (TimestampWrapper.timestampToJson(instance.createdAt)
          case final value?)
        'created_at': value,
      if (AppUtils.userSettingsToJson(instance.userSettings) case final value?)
        'user_settings': value,
      if (AppUtils.geographyToJson(instance.geography) case final value?)
        'geography': value,
      if (instance.isPremium case final value?) 'is_premium': value,
      if (instance.blockedIds case final value?) 'blockedIds': value,
      if (instance.latitude case final value?) 'latitude': value,
      if (instance.longitude case final value?) 'longitude': value,
      if (AppUtils.geoPointToJson(instance.location) case final value?)
        'location': value,
      if (instance.geohash case final value?) 'geohash': value,
      if (instance.creditBalance case final value?) 'credit_balance': value,
      if (AppUtils.paymentToJson(instance.amountPaid) case final value?)
        'amount_paid_in_total': value,
      if (FaceVerification.faceVerificationToJson(instance.faceVerification)
          case final value?)
        'face_verification': value,
      if (instance.currentPlan case final value?) 'current_plan': value,
      if (PaystackUser.paystackUserToJson(instance.paystackUser)
          case final value?)
        'paystack': value,
    };

const _$AuthMethodEnumMap = {
  AuthMethod.local: 'local',
  AuthMethod.google: 'google',
  AuthMethod.phone: 'phone',
  AuthMethod.apple: 'apple',
};
