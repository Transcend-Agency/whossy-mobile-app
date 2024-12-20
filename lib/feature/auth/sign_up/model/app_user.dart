import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/index.dart';
import 'user_status.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser {
  final String? uid;
  final String? email;

  @JsonKey(name: 'first_name')
  final String? firstName;

  @JsonKey(name: 'last_name')
  final String? lastName;

  final String? gender;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  @JsonKey(name: 'country_of_origin')
  final String? countryOfOrigin;

  @JsonKey(name: 'auth_provider')
  final AuthMethod? authProvider;

  final double? weight;
  final double? height;

  @JsonKey(name: 'has_completed_account_creation')
  final bool hasCompletedAccountCreation;

  @JsonKey(name: 'has_completed_onboarding')
  final bool hasCompletedOnboarding;

  @JsonKey(name: 'tokens')
  final List<String>? tokens;

  @JsonKey(name: 'is_verified')
  final bool isVerified;

  @JsonKey(
    name: 'created_at',
    fromJson: AppUtils.timestampFromJson,
    toJson: AppUtils.timestampToJson,
  )
  final Timestamp? createdAt;

  @JsonKey(name: 'status', includeToJson: false)
  final UserStatus? status;

  @JsonKey(name: "isPremium")
  final bool? isPremium;

  @JsonKey(name: "blockedIds")
  final List<String>? blockedIds;

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

  AppUser({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.phoneNumber,
    this.countryOfOrigin,
    this.authProvider,
    this.weight,
    this.height,
    this.hasCompletedAccountCreation = false,
    this.hasCompletedOnboarding = false,
    this.tokens,
    this.isVerified = false,
    this.createdAt,
    this.status,
    this.isPremium = false,
    this.latitude,
    this.longitude,
    this.location,
    this.geohash,
    List<String>? blockedIds,
  }) : blockedIds = blockedIds ?? [];

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  String getName() {
    if (firstName != null && lastName != null) {
      return "$firstName $lastName";
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    } else {
      return "";
    }
  }

  Map<String, dynamic> toUpdateCreate() => {
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'phone_number': phoneNumber,
        'country_of_origin': countryOfOrigin,
        'has_completed_account_creation': hasCompletedAccountCreation,
      };

  @override
  String toString() {
    return 'uid: $uid\n'
        'email: $email\n'
        'firstName: $firstName\n'
        'lastName: $lastName\n'
        'gender: $gender\n'
        'phoneNumber: $phoneNumber\n'
        'countryOfOrigin: $countryOfOrigin\n'
        'authProvider: $authProvider\n'
        'height: $height\n'
        'weight: $weight\n'
        'hasCompletedAccountCreation: $hasCompletedAccountCreation\n'
        'hasCompletedOnboarding: $hasCompletedOnboarding\n'
        'isVerified: $isVerified\n'
        'createdAt: ${createdAt?.toDate()}\n'
        'tokens: ${tokens?.join(", ") ?? "null"}\n'
        'isPremium $isPremium,\n'
        'status: ${status?.toString() ?? "null"}'
        'blockedIds: ${blockedIds?.join(", ") ?? "[]"}';
  }
}
