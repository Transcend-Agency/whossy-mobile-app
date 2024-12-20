import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whossy_app/feature/auth/onboarding/model/preferences.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/profile_data_footer.dart';

import '../../../../common/utils/index.dart';

part 'core_profile.g.dart';
part 'core_profile_utils.dart';

@JsonSerializable()
class CoreProfile implements ProfileDataFooter {
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

  @JsonKey(name: 'country_of_origin')
  final String? countryOfOrigin;

  @JsonKey(name: "isPremium")
  bool? isPremium;

  @JsonKey(name: "is_verified")
  bool? isVerified;

  @JsonKey(name: "blockedIds")
  List<String>? blockedIds;

  @JsonKey(name: "latitude")
  final double? latitude;

  @JsonKey(name: "longitude")
  final double? longitude;

  @JsonKey(
    name: "location",
    toJson: AppUtils.geoPointToJson,
    fromJson: AppUtils.geoPointFromJson,
  )
  final GeoPoint? location;

  @JsonKey(name: "geohash")
  final String? geohash;

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
    this.countryOfOrigin,
    this.isPremium,
    this.isVerified,
    this.blockedIds,
    this.latitude,
    this.longitude,
    this.location,
    this.geohash,
  });

  factory CoreProfile.fromJson(Map<String, dynamic> json) =>
      _$CoreProfileFromJson(json);

  Map<String, dynamic> toJson() => _$CoreProfileToJson(this);

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
        '  countryOfOrigin: $countryOfOrigin,\n'
        '  weight: $weight,\n'
        '  height: $height,\n'
        '  isPremium: $isPremium,\n'
        '  isVerified: $isVerified,\n'
        '  blockedIds: ${blockedIds?.join(", ") ?? "[]"},\n'
        '  latitude: $latitude,\n'
        '  longitude: $longitude,\n'
        '  location: {\n'
        '     longitude: ${location?.longitude},\n'
        '     latitude: ${location?.latitude}, \n },\n'
        '  geohash: $geohash\n'
        ')';
  }

  @override
  bool get isOnline => true;

  @override
  bool? get newUser => null;

  @override
  String get name => firstName ?? " ";

  @override
  int get userAge => dateOfBirth?.age ?? 0;

  @override
  String? get userBio => bio;

  @override
  List<String> get pictures => profilePics ?? [];

  @override
  double? get distance => null;

  @override
  List<String> get userInterests => interests ?? [];

  @override
  bool get premiumUser => isPremium ?? false;

  @override
  bool get isUserVerified => isVerified ?? false;

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
