// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) => Preferences(
      relationshipPref: (json['preference'] as num?)?.toInt(),
      meet: (json['meet'] as num?)?.toInt(),
      dateOfBirth: Preferences._dateTimeFromJson(json['date_of_birth']),
      search: (json['distance'] as num?)?.toInt(),
      ticks: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      education: json['education'] as String?,
      drink: (json['drink'] as num?)?.toInt(),
      smoker: (json['smoke'] as num?)?.toInt(),
      pets: (json['pets'] as List<dynamic>?)?.map((e) => e as String).toList(),
      workOut: (json['workout'] as num?)?.toInt(),
      bio: json['bio'] as String?,
      profilePics:
          (json['photos'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'preference': instance.relationshipPref,
      'meet': instance.meet,
      'date_of_birth': Preferences._dateTimeToJson(instance.dateOfBirth),
      'distance': instance.search,
      'interests': instance.ticks,
      'education': instance.education,
      'drink': instance.drink,
      'smoke': instance.smoker,
      'pets': instance.pets,
      'workout': instance.workOut,
      'bio': instance.bio,
      'photos': instance.profilePics,
    };
