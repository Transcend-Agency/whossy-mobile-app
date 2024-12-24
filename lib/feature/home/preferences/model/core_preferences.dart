import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/index.dart';
import '../../tabs/matching/model/profile_data.dart';
import 'generic_enum.dart';

part 'core_preferences.g.dart';
part 'core_preferences_utils.dart';

@JsonSerializable()
class CorePreferences implements ProfileData {
  // Relationship Preferences
  @JsonKey(
    name: "preference",
    toJson: enumToIndex,
    fromJson: indexToPreference,
  )
  Preference? relationshipPreference;

  @JsonKey(
      name: "marital_status",
      toJson: enumToIndex,
      fromJson: indexToMaritalStatus)
  MaritalStatus? maritalStatus;

  // Personal Attributes
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

  // Lifestyle Preferences
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

  @JsonKey(
    toJson: enumToIndex,
    fromJson: indexToWorkOut,
  )
  WorkOut? workout;

  @JsonKey(
    name: "pet",
    toJson: enumToIndex,
    fromJson: indexToPetOwner,
  )
  PetOwner? petOwner;

  // Beliefs and Values
  @JsonKey(
    toJson: enumToIndex,
    fromJson: indexToReligion,
  )
  Religion? religion;

  @JsonKey(
    toJson: enumToIndex,
    fromJson: indexToDietary,
  )
  Dietary? dietary;

  // Future Planning
  @JsonKey(
    name: "family_goal",
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

  // Methods for ProfileBase Interface
  @override
  String getSmoke() => smoker?.name ?? '';
  @override
  String getDrink() => drinking?.name ?? '';
  @override
  String getWorkOut() => workout?.name ?? '';
  @override
  String getPetOwner() => petOwner?.name ?? '';
  @override
  String getFutureFamilyPlans() => futureFamilyPlans?.name ?? '';
  @override
  String getCommunicationStyle() => communicationStyle?.name ?? '';
  @override
  String getLoveLanguage() => loveLanguage?.name ?? '';
  @override
  String getEducation() => education?.name ?? '';
  @override
  String getRelationshipPreference() => relationshipPreference?.name ?? '';

  // Boolean Flags for Attributes Existence
  @override
  bool get isSmoker => smoker != null;
  @override
  bool get isDrinker => drinking != null;
  @override
  bool get isWorkout => workout != null;
  @override
  bool get isPetOwner => petOwner != null;
  @override
  bool get hasRelationshipPreference => relationshipPreference != null;
  @override
  bool get hasFutureFamilyPlans => futureFamilyPlans != null;
  @override
  bool get hasCommunicationStyle => communicationStyle != null;
  @override
  bool get hasLoveLanguage => loveLanguage != null;
  @override
  bool get hasEducation => education != null;

  // JSON Serialization Methods
  factory CorePreferences.fromJson(Map<String, dynamic> json) =>
      _$CorePreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$CorePreferencesToJson(this);

  // String Representation
  @override
  String toString() {
    return 'CorePreferences(\n'
        '  relationshipPreference: $relationshipPreference,\n'
        '  maritalStatus: $maritalStatus,\n'
        '  education: $education,\n'
        '  loveLanguage: $loveLanguage,\n'
        '  zodiac: $zodiac,\n'
        '  futureFamilyPlans: $futureFamilyPlans,\n'
        '  communicationStyle: $communicationStyle,\n'
        '  smoker: $smoker,\n'
        '  drinking: $drinking,\n'
        '  workout: $workout,\n'
        '  petOwner: $petOwner,\n'
        '  religion: $religion,\n'
        '  dietary: $dietary\n'
        ')';
  }

  // Equality and Hash Code Overrides
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CorePreferences &&
        other.relationshipPreference == relationshipPreference &&
        other.education == education &&
        other.loveLanguage == loveLanguage &&
        other.zodiac == zodiac &&
        other.futureFamilyPlans == futureFamilyPlans &&
        other.communicationStyle == communicationStyle &&
        other.smoker == smoker &&
        other.drinking == drinking &&
        other.workout == workout &&
        other.petOwner == petOwner &&
        other.religion == religion &&
        other.dietary == dietary &&
        other.maritalStatus == maritalStatus;
  }

  @override
  int get hashCode => Object.hash(
        relationshipPreference,
        maritalStatus,
        education,
        loveLanguage,
        zodiac,
        futureFamilyPlans,
        communicationStyle,
        smoker,
        drinking,
        workout,
        petOwner,
        religion,
        dietary,
      );
}
