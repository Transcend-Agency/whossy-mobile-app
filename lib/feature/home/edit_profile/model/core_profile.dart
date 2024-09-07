import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whossy_app/feature/auth/onboarding/model/preferences.dart';

import '../../../../common/utils/index.dart';

part 'core_profile.g.dart';

@JsonSerializable()
class CoreProfile {
  @JsonKey(name: 'first_name')
  String? firstName;

  @JsonKey(name: 'last_name')
  String? lastName;

  @JsonKey(
    name: 'date_of_birth',
    fromJson: Preferences.dateTimeFromJson,
    toJson: Preferences.dateTimeToJson,
  )
  DateTime? dateOfBirth;

  String? gender;

  String? email;

  double? weight;

  double? height;

  @JsonKey(name: 'phone_number')
  String? phoneNumber;

  @JsonKey(name: 'photos')
  List<String>? profilePics;

  String? bio;

  List<String>? interests;

  static const List<String> validKeys = [
    "name",
    "birthday",
    "gender",
    "email",
    "phoneNumber",
    "bio",
    "full_name"
  ];

  CoreProfile({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.email,
    this.phoneNumber,
    this.profilePics,
    this.bio,
    this.interests,
    this.weight,
    this.height,
  });

  factory CoreProfile.fromJson(Map<String, dynamic> json) =>
      _$CoreProfileFromJson(json);

  Map<String, dynamic> toJson() => _$CoreProfileToJson(this);

  void updateFromPreferences(Preferences prefs) {
    dateOfBirth = prefs.dateOfBirth ?? dateOfBirth;
    profilePics = prefs.profilePics ?? profilePics;
    bio = prefs.bio ?? bio;
    interests = prefs.ticks ?? interests;
  }

  static List<String> transferKeys = ['photos', 'bio', 'interests'];

  Map<String, String?> getName() => {
        "firstName": firstName,
        "lastName": lastName,
      };

  dynamic getValue(String key) {
    if (!validKeys.contains(key)) {
      throw ArgumentError("Invalid key: $key");
    }

    final selectedValues = <String, dynamic>{
      "name": firstName,
      "birthday": DateFormat('MMMM d, y').format(dateOfBirth!),
      "gender": gender,
      "email": email,
      "phoneNumber": phoneNumber,
      "bio": bio,
      "full_name": {
        "firstName": firstName,
        "lastName": lastName,
      }
    };

    return selectedValues[key];
  }

  void update({
    String? bio,
    String? gender,
    String? firstName,
    String? lastName,
    double? height,
    double? weight,
    List<String>? interests,
    List<String>? profilePics,
  }) {
    if (bio != null) this.bio = bio;
    if (gender != null) this.gender = gender;
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = lastName;
    if (height != null) this.height = height;
    if (weight != null) this.weight = weight;
    if (interests != null) this.interests = interests;
    if (profilePics != null) this.profilePics = profilePics;
  }

  bool get hasFullName => firstName != null && lastName != null;

  @override
  String toString() {
    return 'CoreProfile(\n'
        '  firstName: $firstName,\n'
        '  lastName: $lastName,\n'
        '  dateOfBirth: $dateOfBirth,\n'
        '  gender: $gender,\n'
        '  email: $email,\n'
        '  phoneNumber: $phoneNumber,\n'
        '  profilePics: $profilePics,\n'
        '  bio: $bio,\n'
        '  interests: $interests,\n'
        '  weight $weight,\n'
        '  height $height,\n'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoreProfile &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        listEquals(other.profilePics, profilePics) &&
        other.bio == bio &&
        other.weight == weight &&
        other.height == height &&
        AppUtils.areListsEqual(other.interests, interests);
  }

  @override
  int get hashCode {
    return firstName.hashCode ^
        lastName.hashCode ^
        dateOfBirth.hashCode ^
        gender.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        profilePics.hashCode ^
        bio.hashCode ^
        weight.hashCode ^
        height.hashCode ^
        interests.hashCode;
  }
}
