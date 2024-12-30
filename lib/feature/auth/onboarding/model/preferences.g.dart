// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) => Preferences(
      relationshipPref: (json['preference'] as num?)?.toInt(),
      meet: (json['meet'] as num?)?.toInt(),
      dateOfBirth: Preferences.dateTimeFromJson(json['date_of_birth']),
      search: (json['distance'] as num?)?.toInt(),
      ticks: (json['interests'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      smoker: (json['smoke'] as num?)?.toInt(),
      drink: (json['drink'] as num?)?.toInt(),
      education: (json['education'] as num?)?.toInt(),
      loveLanguage: (json['love_language'] as num?)?.toInt(),
      communicationStyle: (json['communication_style'] as num?)?.toInt(),
      zodiac: (json['zodiac'] as num?)?.toInt(),
      religion: (json['religion'] as num?)?.toInt(),
      dietary: (json['dietary'] as num?)?.toInt(),
      futureFamilyPlans: (json['family_goal'] as num?)?.toInt(),
      workOut: (json['workout'] as num?)?.toInt(),
      petOwner: (json['pets'] as num?)?.toInt(),
      bio: json['bio'] as String?,
      maritalStatus: (json['marital_status'] as num?)?.toInt(),
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
  writeNotNull('bio', instance.bio);
  writeNotNull('meet', instance.meet);
  writeNotNull('distance', instance.search);
  writeNotNull(
      'date_of_birth', Preferences.dateTimeToJson(instance.dateOfBirth));
  writeNotNull('interests', instance.ticks);
  writeNotNull('smoke', instance.smoker);
  writeNotNull('drink', instance.drink);
  writeNotNull('education', instance.education);
  writeNotNull('love_language', instance.loveLanguage);
  writeNotNull('communication_style', instance.communicationStyle);
  writeNotNull('zodiac', instance.zodiac);
  writeNotNull('religion', instance.religion);
  writeNotNull('dietary', instance.dietary);
  writeNotNull('family_goal', instance.futureFamilyPlans);
  writeNotNull('workout', instance.workOut);
  writeNotNull('pets', instance.petOwner);
  writeNotNull('marital_status', instance.maritalStatus);
  writeNotNull('photos', instance.profilePics);
  return val;
}
