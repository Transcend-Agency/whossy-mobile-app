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
      drink: (json['drink'] as num?)?.toInt(),
      smoker: (json['smoke'] as num?)?.toInt(),
      education: (json['education'] as num?)?.toInt(),
      loveLanguage: (json['love_language'] as num?)?.toInt(),
      communicationStyle: (json['communication_style'] as num?)?.toInt(),
      zodiac: (json['zodiac'] as num?)?.toInt(),
      religion: (json['religion'] as num?)?.toInt(),
      dietary: (json['dietary'] as num?)?.toInt(),
      futureFamilyPlans: (json['family_plans'] as num?)?.toInt(),
      workOut: (json['workout'] as num?)?.toInt(),
      petOwner: (json['pet'] as num?)?.toInt(),
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
  writeNotNull('meet', instance.meet);
  writeNotNull(
      'date_of_birth', Preferences.dateTimeToJson(instance.dateOfBirth));
  writeNotNull('distance', instance.search);
  writeNotNull('interests', instance.ticks);
  writeNotNull('drink', instance.drink);
  writeNotNull('smoke', instance.smoker);
  writeNotNull('education', instance.education);
  writeNotNull('love_language', instance.loveLanguage);
  writeNotNull('communication_style', instance.communicationStyle);
  writeNotNull('zodiac', instance.zodiac);
  writeNotNull('religion', instance.religion);
  writeNotNull('dietary', instance.dietary);
  writeNotNull('family_plans', instance.futureFamilyPlans);
  writeNotNull('workout', instance.workOut);
  writeNotNull('pet', instance.petOwner);
  writeNotNull('bio', instance.bio);
  writeNotNull('marital_status', instance.maritalStatus);
  writeNotNull('photos', instance.profilePics);
  return val;
}
