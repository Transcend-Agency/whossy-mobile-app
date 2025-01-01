import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whossy_app/feature/auth/sign_up/model/payment.dart';
import 'package:whossy_app/feature/home/settings/model/user_settings.dart';

import '../../../../common/utils/index.dart';
import 'geography.dart';
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

  @JsonKey(name: 'is_approved')
  final bool isApproved;

  @JsonKey(name: 'is_banned')
  final bool isBanned;

  @JsonKey(
    name: 'created_at',
    fromJson: TimestampWrapper.timestampFromJson,
    toJson: TimestampWrapper.timestampToJson,
  )
  final TimestampWrapper? createdAt;

  @JsonKey(name: 'status', includeToJson: false)
  final UserStatus? status;

  @JsonKey(
    name: 'user_settings',
    fromJson: AppUtils.userSettingsFromJson,
    toJson: AppUtils.userSettingsToJson,
  )
  final UserSettings userSettings;

  @JsonKey(
    name: 'geography',
    toJson: AppUtils.geographyToJson,
    fromJson: AppUtils.geographyFromJson,
  )
  final Geography? geography;

  @JsonKey(name: "is_premium")
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

  @JsonKey(name: "credit_balance")
  final int? creditBalance;

  @JsonKey(
    name: "amount_paid_in_total",
    toJson: AppUtils.paymentToJson,
    fromJson: AppUtils.paymentFromJson,
  )
  final Payment? amountPaid;

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
    this.isApproved = false,
    this.isBanned = false,
    this.createdAt,
    this.status,
    UserSettings? userSettings,
    this.isPremium = false,
    this.latitude,
    this.longitude,
    this.location,
    this.geohash,
    this.geography,
    this.creditBalance = 0,
    Payment? payment,
    List<String>? blockedIds,
  })  : userSettings = userSettings ?? UserSettings(),
        amountPaid = payment ?? Payment(),
        blockedIds = blockedIds ?? [];

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
        'isApproved: $isApproved\n'
        'createdAt: ${createdAt?.toString()}\n'
        'tokens: ${tokens?.join(", ") ?? "null"}\n'
        'isPremium $isPremium,\n'
        'status: ${status?.toString() ?? "null"}'
        'blockedIds: ${blockedIds?.join(", ") ?? "[]"}';
  }
}
