// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'core_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CorePreferences _$CorePreferencesFromJson(Map<String, dynamic> json) =>
    CorePreferences(
      relationshipPreference:
          indexToPreference((json['preference'] as num?)?.toInt()),
      education: indexToSchool((json['education'] as num?)?.toInt()),
      loveLanguage:
          indexToLoveLanguage((json['love_language'] as num?)?.toInt()),
      zodiac: indexToZodiac((json['zodiac'] as num?)?.toInt()),
      futureFamilyPlans:
          indexToFutureFamilyPlans((json['family_goal'] as num?)?.toInt()),
      communicationStyle: indexToCommunicationStyle(
          (json['communication_style'] as num?)?.toInt()),
      smoker: indexToSmoke((json['smoke'] as num?)?.toInt()),
      drinking: indexToDrink((json['drink'] as num?)?.toInt()),
      workout: indexToWorkOut((json['workout'] as num?)?.toInt()),
      petOwner: indexToPetOwner((json['pets'] as num?)?.toInt()),
      religion: indexToReligion((json['religion'] as num?)?.toInt()),
      dietary: indexToDietary((json['dietary'] as num?)?.toInt()),
      maritalStatus:
          indexToMaritalStatus((json['marital_status'] as num?)?.toInt()),
    );

Map<String, dynamic> _$CorePreferencesToJson(CorePreferences instance) =>
    <String, dynamic>{
      if (enumToIndex(instance.relationshipPreference) case final value?)
        'preference': value,
      if (enumToIndex(instance.maritalStatus) case final value?)
        'marital_status': value,
      if (enumToIndex(instance.education) case final value?) 'education': value,
      if (enumToIndex(instance.loveLanguage) case final value?)
        'love_language': value,
      if (enumToIndex(instance.zodiac) case final value?) 'zodiac': value,
      if (enumToIndex(instance.smoker) case final value?) 'smoke': value,
      if (enumToIndex(instance.drinking) case final value?) 'drink': value,
      if (enumToIndex(instance.workout) case final value?) 'workout': value,
      if (enumToIndex(instance.petOwner) case final value?) 'pets': value,
      if (enumToIndex(instance.religion) case final value?) 'religion': value,
      if (enumToIndex(instance.dietary) case final value?) 'dietary': value,
      if (enumToIndex(instance.futureFamilyPlans) case final value?)
        'family_goal': value,
      if (enumToIndex(instance.communicationStyle) case final value?)
        'communication_style': value,
    };
