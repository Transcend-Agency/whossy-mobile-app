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
          indexToFutureFamilyPlans((json['family_plans'] as num?)?.toInt()),
      communicationStyle: indexToCommunicationStyle(
          (json['communication_style'] as num?)?.toInt()),
      smoker: indexToSmoke((json['smoke'] as num?)?.toInt()),
      drinking: indexToDrink((json['drink'] as num?)?.toInt()),
      workout: indexToWorkOut((json['workout'] as num?)?.toInt()),
      petOwner: indexToPetOwner((json['pet'] as num?)?.toInt()),
      religion: indexToReligion((json['religion'] as num?)?.toInt()),
      dietary: indexToDietary((json['dietary'] as num?)?.toInt()),
      maritalStatus:
          indexToMaritalStatus((json['marital_status'] as num?)?.toInt()),
    );

Map<String, dynamic> _$CorePreferencesToJson(CorePreferences instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('preference', enumToIndex(instance.relationshipPreference));
  writeNotNull('education', enumToIndex(instance.education));
  writeNotNull('love_language', enumToIndex(instance.loveLanguage));
  writeNotNull('zodiac', enumToIndex(instance.zodiac));
  writeNotNull('family_plans', enumToIndex(instance.futureFamilyPlans));
  writeNotNull('communication_style', enumToIndex(instance.communicationStyle));
  writeNotNull('smoke', enumToIndex(instance.smoker));
  writeNotNull('drink', enumToIndex(instance.drinking));
  writeNotNull('workout', enumToIndex(instance.workout));
  writeNotNull('pet', enumToIndex(instance.petOwner));
  writeNotNull('religion', enumToIndex(instance.religion));
  writeNotNull('dietary', enumToIndex(instance.dietary));
  writeNotNull('marital_status', enumToIndex(instance.maritalStatus));
  return val;
}
