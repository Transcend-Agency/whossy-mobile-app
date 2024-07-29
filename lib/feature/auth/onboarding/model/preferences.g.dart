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

Map<String, dynamic> _$PreferencesToJson(Preferences instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('preference', instance.relationshipPref);
  writeNotNull('meet', instance.meet);
  writeNotNull(
      'date_of_birth', Preferences._dateTimeToJson(instance.dateOfBirth));
  writeNotNull('distance', instance.search);
  writeNotNull('interests', instance.ticks);
  writeNotNull('education', instance.education);
  writeNotNull('drink', instance.drink);
  writeNotNull('smoke', instance.smoker);
  writeNotNull('pets', instance.pets);
  writeNotNull('workout', instance.workOut);
  writeNotNull('bio', instance.bio);
  writeNotNull('photos', instance.profilePics);
  return val;
}
