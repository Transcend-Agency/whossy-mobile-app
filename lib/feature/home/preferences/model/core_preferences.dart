import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/index.dart';
import 'generic_enum.dart';

part 'core_preferences.g.dart';

@JsonSerializable()
class CorePreferences {
  @JsonKey(
    name: "preference",
    toJson: enumToIndex,
    fromJson: indexToPreference,
  )
  Preference? relationshipPreference;

  @JsonKey(
    toJson: enumToIndex,
    fromJson: indexToSchool,
  )
  School? education;

  @JsonKey(
    name: "love_language",
    toJson: enumToIndex,
    fromJson: indexToLoveLanguage,
  )
  LoveLanguage? loveLanguage;

  @JsonKey(
    toJson: enumToIndex,
    fromJson: indexToZodiac,
  )
  Zodiac? zodiac;

  @JsonKey(
    name: "family_plans",
    toJson: enumToIndex,
    fromJson: indexToFutureFamilyPlans,
  )
  FutureFamilyPlans? futureFamilyPlans;

  @JsonKey(
    name: "communication_style",
    toJson: enumToIndex,
    fromJson: indexToCommunicationStyle,
  )
  CommunicationStyle? communicationStyle;

  @JsonKey(
    name: "smoke",
    toJson: enumToIndex,
    fromJson: indexToSmoke,
  )
  Smoke? smoker;

  @JsonKey(
    name: "drink",
    toJson: enumToIndex,
    fromJson: indexToDrink,
  )
  Drink? drinking;

  @JsonKey(toJson: enumToIndex, fromJson: indexToWorkOut)
  WorkOut? workout;

  @JsonKey(
    toJson: enumToIndex,
    fromJson: indexToPetOwner,
  )
  PetOwner? petOwner;

  @JsonKey(toJson: enumToIndex, fromJson: indexToReligion)
  Religion? religion;

  @JsonKey(toJson: enumToIndex, fromJson: indexToDietary)
  Dietary? dietary;

  @JsonKey(
    name: "marital_status",
    toJson: enumToIndex,
    fromJson: indexToMaritalStatus,
  )
  MaritalStatus? maritalStatus;

  CorePreferences({
    this.relationshipPreference,
    this.education,
    this.loveLanguage,
    this.zodiac,
    this.futureFamilyPlans,
    this.communicationStyle,
    this.smoker,
    this.drinking,
    this.workout,
    this.petOwner,
    this.religion,
    this.dietary,
    this.maritalStatus,
  });

  GenericEnum? getValue(Type type) {
    final selectedValues = <Type, GenericEnum?>{
      Preference: relationshipPreference,
      School: education,
      LoveLanguage: loveLanguage,
      Zodiac: zodiac,
      FutureFamilyPlans: futureFamilyPlans,
      CommunicationStyle: communicationStyle,
      Smoke: smoker,
      Drink: drinking,
      WorkOut: workout,
      PetOwner: petOwner,
      Religion: religion,
      Dietary: dietary,
      MaritalStatus: maritalStatus,
    };

    return selectedValues[type];
  }

  void setValue(GenericEnum value) {
    if (value is Preference) {
      relationshipPreference = value;
    } else if (value is School) {
      education = value;
    } else if (value is LoveLanguage) {
      loveLanguage = value;
    } else if (value is Zodiac) {
      zodiac = value;
    } else if (value is FutureFamilyPlans) {
      futureFamilyPlans = value;
    } else if (value is CommunicationStyle) {
      communicationStyle = value;
    } else if (value is Smoke) {
      smoker = value;
    } else if (value is Drink) {
      drinking = value;
    } else if (value is WorkOut) {
      workout = value;
    } else if (value is PetOwner) {
      petOwner = value;
    } else if (value is Religion) {
      religion = value;
    } else if (value is Dietary) {
      dietary = value;
    } else if (value is MaritalStatus) {
      maritalStatus = value;
    } else {
      // Do nothing
    }
  }

  factory CorePreferences.fromJson(Map<String, dynamic> json) =>
      _$CorePreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$CorePreferencesToJson(this);

  @override
  String toString() {
    return 'CorePreferences('
        'relationshipPreference: $relationshipPreference, '
        'education: $education, '
        'loveLanguage: $loveLanguage, '
        'zodiac: $zodiac, '
        'futureFamilyPlans: $futureFamilyPlans, '
        'communicationStyle: $communicationStyle, '
        'smoker: $smoker, '
        'drinking: $drinking, '
        'workout: $workout, '
        'petOwner: $petOwner, '
        'religion: $religion, '
        'dietary: $dietary, '
        'maritalStatus: $maritalStatus'
        ')';
  }
}
