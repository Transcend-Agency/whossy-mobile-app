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

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      if (instance.relationshipPref case final value?) 'preference': value,
      if (instance.bio case final value?) 'bio': value,
      if (instance.meet case final value?) 'meet': value,
      if (instance.search case final value?) 'distance': value,
      if (Preferences.dateTimeToJson(instance.dateOfBirth) case final value?)
        'date_of_birth': value,
      if (instance.ticks case final value?) 'interests': value,
      if (instance.smoker case final value?) 'smoke': value,
      if (instance.drink case final value?) 'drink': value,
      if (instance.education case final value?) 'education': value,
      if (instance.loveLanguage case final value?) 'love_language': value,
      if (instance.communicationStyle case final value?)
        'communication_style': value,
      if (instance.zodiac case final value?) 'zodiac': value,
      if (instance.religion case final value?) 'religion': value,
      if (instance.dietary case final value?) 'dietary': value,
      if (instance.futureFamilyPlans case final value?) 'family_goal': value,
      if (instance.workOut case final value?) 'workout': value,
      if (instance.petOwner case final value?) 'pets': value,
      if (instance.maritalStatus case final value?) 'marital_status': value,
      if (instance.profilePics case final value?) 'photos': value,
    };
