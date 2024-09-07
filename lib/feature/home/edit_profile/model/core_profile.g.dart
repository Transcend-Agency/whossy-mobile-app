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
  return val;
}
