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
      userSettings: json['user_settings'] == null
          ? null
          : UserSettings.fromJson(
              json['user_settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CoreProfileToJson(CoreProfile instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('first_name', instance.firstName);
  writeNotNull('last_name', instance.lastName);
  writeNotNull(
      'date_of_birth', Preferences.dateTimeToJson(instance.dateOfBirth));
  writeNotNull('gender', instance.gender);
  writeNotNull('email', instance.email);
  writeNotNull('weight', instance.weight);
  writeNotNull('height', instance.height);
  writeNotNull('phone_number', instance.phoneNumber);
  writeNotNull('photos', instance.profilePics);
  writeNotNull('bio', instance.bio);
  writeNotNull('interests', instance.interests);
  writeNotNull('country_of_origin', instance.countryOfOrigin);
  writeNotNull('is_premium', instance.isPremium);
  writeNotNull('is_approved', instance.isApproved);
  writeNotNull('is_banned', instance.isBanned);
  writeNotNull('blockedIds', instance.blockedIds);
  writeNotNull('latitude', instance.latitude);
  writeNotNull('longitude', instance.longitude);
  writeNotNull('location', AppUtils.geoPointToJson(instance.location));
  writeNotNull('geohash', instance.geohash);
  writeNotNull('credit_balance', instance.creditBalance);
  writeNotNull('user_settings', instance.userSettings);
  return val;
}
