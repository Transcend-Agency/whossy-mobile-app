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
      userSettings: json['user_settings'] == null
          ? null
          : UserSettings.fromJson(
              json['user_settings'] as Map<String, dynamic>),
      isPremium: json['is_premium'] as bool? ?? false,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      location: AppUtils.geoPointFromJson(json['location']),
      geohash: json['geohash'] as String?,
      geography: AppUtils.geographyFromJson(
          json['geography'] as Map<String, dynamic>?),
      creditBalance: (json['credit_balance'] as num?)?.toInt() ?? 0,
      amountPaid: (json['amount_paid_in_total'] as num?)?.toDouble() ?? 0,
      blockedIds: (json['blockedIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
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
  val['is_approved'] = instance.isApproved;
  val['is_banned'] = instance.isBanned;
  writeNotNull(
      'created_at', TimestampWrapper.timestampToJson(instance.createdAt));
  writeNotNull('user_settings', instance.userSettings);
  writeNotNull('geography', AppUtils.geographyToJson(instance.geography));
  writeNotNull('is_premium', instance.isPremium);
  writeNotNull('blockedIds', instance.blockedIds);
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  writeNotNull('location', AppUtils.geoPointToJson(instance.location));
  writeNotNull('geohash', instance.geohash);
  writeNotNull('credit_balance', instance.creditBalance);
  writeNotNull('amount_paid_in_total', instance.amountPaid);
  return val;
}

const _$AuthMethodEnumMap = {
  AuthMethod.local: 'local',
  AuthMethod.google: 'google',
  AuthMethod.phone: 'phone',
};
