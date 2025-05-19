// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CoreProfile _$CoreProfileFromJson(Map<String, dynamic> json) => CoreProfile(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      dateOfBirth: Preferences.dateTimeFromJson(json['date_of_birth']),
      gender: json['gender'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      profilePics:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
      bio: json['bio'] as String?,
      meet: (json['meet'] as num?)?.toInt(),
      interests: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      countryOfOrigin: json['country_of_origin'] as String?,
      isPremium: json['is_premium'] as bool?,
      isApproved: json['is_approved'] as bool?,
      blockedIds: (json['blockedIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      location: AppUtils.geoPointFromJson(json['location']),
      geohash: json['geohash'] as String?,
      isBanned: json['is_banned'] as bool?,
      creditBalance: (json['credit_balance'] as num?)?.toInt(),
      userSettings: AppUtils.userSettingsFromJson(
          json['user_settings'] as Map<String, dynamic>?),
      amountPaid: AppUtils.paymentFromJson(
          json['amount_paid_in_total'] as Map<String, dynamic>?),
      geography: AppUtils.geographyFromJson(
          json['geography'] as Map<String, dynamic>?),
      faceVerification: FaceVerification.faceVerificationFromJson(
          json['face_verification'] as Map<String, dynamic>?),
      currentPlan: json['current_plan'] as String?,
      paymentPlatform: $enumDecodeNullable(
          _$PaymentPlatformEnumMap, json['payment_platform']),
    );

Map<String, dynamic> _$CoreProfileToJson(CoreProfile instance) =>
    <String, dynamic>{
      if (instance.firstName case final value?) 'first_name': value,
      if (instance.lastName case final value?) 'last_name': value,
      if (Preferences.dateTimeToJson(instance.dateOfBirth) case final value?)
        'date_of_birth': value,
      if (instance.gender case final value?) 'gender': value,
      if (instance.email case final value?) 'email': value,
      if (instance.weight case final value?) 'weight': value,
      if (instance.height case final value?) 'height': value,
      if (instance.phoneNumber case final value?) 'phone_number': value,
      if (instance.profilePics case final value?) 'photos': value,
      if (instance.bio case final value?) 'bio': value,
      if (instance.meet case final value?) 'meet': value,
      if (instance.interests case final value?) 'interests': value,
      if (instance.countryOfOrigin case final value?)
        'country_of_origin': value,
      if (instance.isPremium case final value?) 'is_premium': value,
      if (instance.isApproved case final value?) 'is_approved': value,
      if (instance.isBanned case final value?) 'is_banned': value,
      if (instance.blockedIds case final value?) 'blockedIds': value,
      if (instance.latitude case final value?) 'latitude': value,
      if (instance.longitude case final value?) 'longitude': value,
      if (AppUtils.geoPointToJson(instance.location) case final value?)
        'location': value,
      if (instance.geohash case final value?) 'geohash': value,
      if (AppUtils.geographyToJson(instance.geography) case final value?)
        'geography': value,
      if (instance.creditBalance case final value?) 'credit_balance': value,
      if (instance.currentPlan case final value?) 'current_plan': value,
      if (AppUtils.paymentToJson(instance.amountPaid) case final value?)
        'amount_paid_in_total': value,
      if (AppUtils.userSettingsToJson(instance.userSettings) case final value?)
        'user_settings': value,
      if (FaceVerification.faceVerificationToJson(instance.faceVerification)
          case final value?)
        'face_verification': value,
      if (_$PaymentPlatformEnumMap[instance.paymentPlatform] case final value?)
        'payment_platform': value,
    };

const _$PaymentPlatformEnumMap = {
  PaymentPlatform.web: 'web',
  PaymentPlatform.mobile: 'mobile',
};
