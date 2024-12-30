import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/index.dart';
import '../../../home/tabs/matching/model/profile_data.dart';

part 'preferences.g.dart';
part 'preferences_utils.dart';

@JsonSerializable()
class Preferences implements ProfileData {
  // Relationship preference and bio
  @JsonKey(name: 'preference')
  int? relationshipPref;

  @JsonKey(name: 'bio')
  String? bio;

  // Match-related preferences
  int? meet;
  @JsonKey(name: 'distance')
  int? search;

  // Core preferences (with JSON serialization)
  @JsonKey(
    name: 'date_of_birth',
    fromJson: dateTimeFromJson,
    toJson: dateTimeToJson,
  )
  DateTime? dateOfBirth;

  @JsonKey(name: 'interests')
  List<String>? ticks;

  @JsonKey(name: 'smoke')
  int? smoker;

  int? drink;
  int? education;

  @JsonKey(name: "love_language")
  int? loveLanguage;

  @JsonKey(name: "communication_style")
  int? communicationStyle;

  int? zodiac;
  int? religion;
  int? dietary;

  @JsonKey(name: "family_goal")
  int? futureFamilyPlans;

  @JsonKey(name: 'workout')
  int? workOut;

  // Todo: Refactor to pets
  @JsonKey(name: "pets")
  int? petOwner;

  @JsonKey(name: "marital_status")
  int? maritalStatus;

  // Profile pictures
  @JsonKey(name: 'photos')
  List<String>? profilePics;

  @JsonKey(includeFromJson: false, includeToJson: false)
  List<File>? picFiles;

  Preferences({
    this.relationshipPref,
    this.meet,
    this.dateOfBirth,
    this.search,
    this.ticks,
    this.smoker,
    this.drink,
    this.education,
    this.loveLanguage,
    this.communicationStyle,
    this.zodiac,
    this.religion,
    this.dietary,
    this.futureFamilyPlans,
    this.workOut,
    this.petOwner,
    this.bio,
    this.maritalStatus,
    this.profilePics,
    this.picFiles,
  });

  // Implementations from ProfileBase
  @override
  String getSmoke() => indexToSmoke(smoker!)!.name;
  @override
  String getDrink() => indexToDrink(drink!)!.name;
  @override
  String getWorkOut() => indexToWorkOut(workOut!)!.name;
  @override
  String getPetOwner() => indexToPetOwner(petOwner!)!.name;
  @override
  String getFutureFamilyPlans() =>
      indexToFutureFamilyPlans(futureFamilyPlans!)!.name;
  @override
  String getCommunicationStyle() =>
      indexToCommunicationStyle(communicationStyle!)!.name;
  @override
  String getLoveLanguage() => indexToLoveLanguage(loveLanguage!)!.name;
  @override
  String getEducation() => indexToSchool(education!)!.name;

  @override
  String getRelationshipPreference() =>
      indexToPreference(relationshipPref!)!.name;

  // Boolean checks from ProfileBase
  @override
  bool get isSmoker => smoker != null;
  @override
  bool get isDrinker => drink != null;
  @override
  bool get isWorkout => workOut != null;
  @override
  bool get isPetOwner => petOwner != null;
  @override
  bool get hasFutureFamilyPlans => futureFamilyPlans != null;
  @override
  bool get hasCommunicationStyle => communicationStyle != null;
  @override
  bool get hasLoveLanguage => loveLanguage != null;
  @override
  bool get hasEducation => education != null;

  @override
  bool get hasRelationshipPreference => relationshipPref != null;

  // JSON serialization and custom date handling
  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);
  Map<String, dynamic> toJson() => _$PreferencesToJson(this);

  static DateTime? dateTimeFromJson(dynamic json) {
    if (json is Timestamp) return json.toDate();
    if (json is String) return DateTime.parse(json);
    return null;
  }

  static dynamic dateTimeToJson(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;

  // String representation for debugging
  @override
  String toString() {
    return 'relationshipPref: $relationshipPref\n'
        'meet: $meet\n'
        'dateOfBirth: $dateOfBirth\n'
        'search: $search\n'
        'ticks: ${ticks?.join(", ")}\n'
        'smoker: $smoker\n'
        'drink: $drink\n'
        'education: $education\n'
        'loveLanguage: $loveLanguage\n'
        'communicationStyle: $communicationStyle\n'
        'zodiac: $zodiac\n'
        'religion: $religion\n'
        'dietary: $dietary\n'
        'futureFamilyPlans: $futureFamilyPlans\n'
        'workOut: $workOut\n'
        'petOwner: $petOwner\n'
        'bio: $bio\n'
        'maritalStatus: $maritalStatus\n'
        'profilePics: ${profilePics?.join(", ")}\n'
        'picFiles: ${picFiles?.map((file) => file.path).join(", ")}';
  }
}
