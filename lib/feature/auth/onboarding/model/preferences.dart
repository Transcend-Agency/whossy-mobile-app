import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preferences.g.dart';

@JsonSerializable()
class Preferences {
  @JsonKey(name: 'preference')
  int? relationshipPref;

  int? meet;

  @JsonKey(
    name: 'date_of_birth',
    fromJson: dateTimeFromJson,
    toJson: dateTimeToJson,
  )
  DateTime? dateOfBirth;

  @JsonKey(name: 'distance')
  int? search;

  @JsonKey(name: 'interests')
  List<String>? ticks;

  int? drink;

  @JsonKey(name: 'smoke')
  int? smoker;

  int? education;

  @JsonKey(name: "love_language")
  int? loveLanguage;

  @JsonKey(name: "communication_style")
  int? communicationStyle;

  int? zodiac;

  int? religion;

  int? dietary;

  @JsonKey(name: "family_plans")
  int? futureFamilyPlans;

  @JsonKey(name: 'workout')
  int? workOut;

  @JsonKey(name: "pet")
  int? petOwner;

  @JsonKey(name: 'bio')
  String? bio;

  @JsonKey(name: "marital_status")
  int? maritalStatus;

  @JsonKey(name: 'photos')
  List<String>? profilePics;

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
  )
  List<File>? picFiles;

  Preferences({
    this.relationshipPref,
    this.meet,
    this.dateOfBirth,
    this.search,
    this.ticks,
    this.drink,
    this.smoker,
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

  void update({
    int? relationshipPref,
    int? meet,
    DateTime? dateOfBirth,
    int? search,
    List<String>? ticks,
    int? drink,
    int? smoker,
    int? education,
    int? loveLanguage,
    int? communicationStyle,
    int? zodiac,
    int? religion,
    int? dietary,
    int? futureFamilyPlans,
    int? workOut,
    int? petOwner,
    String? bio,
    int? maritalStatus,
    List<String>? profilePics,
    List<File>? picFiles,
  }) {
    if (relationshipPref != null) this.relationshipPref = relationshipPref;
    if (meet != null) this.meet = meet;
    if (dateOfBirth != null) this.dateOfBirth = dateOfBirth;
    if (search != null) this.search = search;
    if (ticks != null) this.ticks = ticks;
    if (drink != null) this.drink = drink;
    if (smoker != null) this.smoker = smoker;
    if (education != null) this.education = education;
    if (loveLanguage != null) this.loveLanguage = loveLanguage;
    if (communicationStyle != null) {
      this.communicationStyle = communicationStyle;
    }
    if (zodiac != null) this.zodiac = zodiac;
    if (religion != null) this.religion = religion;
    if (dietary != null) this.dietary = dietary;
    if (futureFamilyPlans != null) this.futureFamilyPlans = futureFamilyPlans;
    if (workOut != null) this.workOut = workOut;
    if (petOwner != null) this.petOwner = petOwner;
    if (bio != null) this.bio = bio;
    if (maritalStatus != null) this.maritalStatus = maritalStatus;
    if (profilePics != null) this.profilePics = profilePics;
    if (picFiles != null) this.picFiles = picFiles;
  }

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$PreferencesToJson(this);

  // Custom fromJson method for dateOfBirth
  static DateTime? dateTimeFromJson(dynamic json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    }
    return null;
  }

  // Custom toJson method for dateOfBirth
  static dynamic dateTimeToJson(DateTime? date) {
    return date != null ? Timestamp.fromDate(date) : null;
  }

  @override
  String toString() {
    return 'relationshipPref: $relationshipPref\n'
        'meet: $meet\n'
        'dateOfBirth: $dateOfBirth\n'
        'search: $search\n'
        'ticks: ${ticks?.join(" ")}\n'
        'drink: $drink\n'
        'smoker: $smoker\n'
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
        'profilePics: ${profilePics?.join(" ")}\n'
        'picFiles: ${picFiles?.map((file) => file.path).join(" ")}';
  }
}
