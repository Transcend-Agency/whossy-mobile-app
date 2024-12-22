import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whossy_app/feature/auth/onboarding/model/preferences.dart';
import 'package:whossy_app/feature/home/edit_profile/data/source/extensions.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/profile_data_footer.dart';

import '../../../../common/utils/index.dart';
import '../../settings/model/user_settings.dart';

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
  String? countryOfOrigin;

  @JsonKey(name: "is_premium")
  bool? isPremium;

  @JsonKey(name: "is_approved")
  bool? isApproved;

  @JsonKey(name: 'is_banned')
  bool? isBanned;

  @JsonKey(name: "blockedIds")
  List<String>? blockedIds;

  @JsonKey(name: "latitude")
  double? latitude;

  @JsonKey(name: "longitude")
  double? longitude;

  @JsonKey(
    name: "location",
    toJson: AppUtils.geoPointToJson,
    fromJson: AppUtils.geoPointFromJson,
  )
  GeoPoint? location;

  @JsonKey(name: "geohash")
  String? geohash;

  @JsonKey(name: "credit_balance")
  int? creditBalance;

  @JsonKey(name: "amount_paid_in_total")
  double? amountPaid;

  @JsonKey(name: 'user_settings')
  final UserSettings? userSettings;

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
    this.isApproved,
    this.blockedIds,
    this.latitude,
    this.longitude,
    this.location,
    this.geohash,
    this.isBanned,
    this.creditBalance,
    this.userSettings,
    this.amountPaid,
  });

  factory CoreProfile.fromJson(Map<String, dynamic> json) =>
      _$CoreProfileFromJson(json);

  Map<String, dynamic> toJson() => _$CoreProfileToJson(this);

  @override
  String toString() {
    return 'CoreProfile(\n'
        '  firstName: $firstName,\n'
        '  lastName: $lastName,\n'
        '  dateOfBirth: ${dateOfBirth != null ? DateFormat.yMd().format(dateOfBirth!) : "null"},\n'
        '  gender: $gender,\n'
        '  email: $email,\n'
        '  phoneNumber: $phoneNumber,\n'
        '  profilePics: ${profilePics?.join(", ") ?? "null"},\n'
        '  bio: $bio,\n'
        '  interests: ${interests?.join(", ") ?? "null"},\n'
        '  weight: $weight,\n'
        '  height: $height,\n'
        '  countryOfOrigin: $countryOfOrigin,\n'
        '  isPremium: $isPremium,\n'
        '  isApproved: $isApproved,\n'
        '  isBanned: $isBanned,\n'
        '  blockedIds: ${blockedIds?.join(", ") ?? "null"},\n'
        '  latitude: $latitude,\n'
        '  longitude: $longitude,\n'
        '  location: {\n'
        '    latitude: ${location?.latitude ?? "null"},\n'
        '    longitude: ${location?.longitude ?? "null"}\n'
        '  },\n'
        '  geohash: $geohash,\n'
        '  creditBalance: $creditBalance,\n'
        '  userSettings: $userSettings\n'
        '  amountPaid: $amountPaid\n'
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
  bool get isUserVerified => isApproved ?? false;

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
        AppUtils.areListsEqual(other.interests, interests) &&
        other.weight == weight &&
        other.height == height &&
        other.isPremium == isPremium &&
        other.isApproved == isApproved &&
        other.isBanned == isBanned &&
        AppUtils.areListsEqual(other.blockedIds, blockedIds) &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.location == location &&
        other.geohash == geohash &&
        other.creditBalance == creditBalance &&
        other.amountPaid == amountPaid &&
        other.userSettings == userSettings;
  }

  @override
  int get hashCode {
    return Object.hash(
      firstName,
      lastName,
      dateOfBirth,
      gender,
      email,
      phoneNumber,
      bio,
      weight,
      height,
      isPremium,
      isApproved,
      isBanned,
      location,
      geohash,
      creditBalance,
      amountPaid,
      userSettings,
      Object.hashAll(profilePics ?? []),
      Object.hashAll(interests ?? []),
      Object.hashAll(blockedIds ?? []),
    );
  }
}
