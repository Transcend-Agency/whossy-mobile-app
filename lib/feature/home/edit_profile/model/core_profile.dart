import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whossy_app/common/utils/services/payment/paystack/model/paystack_user.dart';
import 'package:whossy_app/feature/auth/onboarding/model/preferences.dart';

import '../../../../common/utils/utils.dart';
import '../../../auth/onboarding/model/face_verification.dart';
import '../../../auth/sign_up/model/geography.dart';
import '../../../auth/sign_up/model/payment.dart';
import '../../settings/model/user_settings.dart';

part 'core_profile.g.dart';
part 'core_profile_utils.dart';

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

  int? meet;

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

  @JsonKey(
    name: 'geography',
    toJson: AppUtils.geographyToJson,
    fromJson: AppUtils.geographyFromJson,
  )
  Geography? geography;

  @JsonKey(name: "credit_balance")
  int? creditBalance;

  @JsonKey(name: "current_plan")
  int? currentPlan;

  @JsonKey(
    name: "amount_paid_in_total",
    toJson: AppUtils.paymentToJson,
    fromJson: AppUtils.paymentFromJson,
  )
  Payment? amountPaid;

  @JsonKey(
    name: 'user_settings',
    fromJson: AppUtils.userSettingsFromJson,
    toJson: AppUtils.userSettingsToJson,
  )
  UserSettings? userSettings;

  @JsonKey(
    name: "face_verification",
    fromJson: FaceVerification.faceVerificationFromJson,
    toJson: FaceVerification.faceVerificationToJson,
  )
  FaceVerification? faceVerification;

  @JsonKey(includeToJson: false, includeFromJson: false)
  String? updatedPhoto;

  @JsonKey(
    name: 'paystack',
    fromJson: PaystackUser.paystackUserFromJson,
    toJson: PaystackUser.paystackUserToJson,
  )
  PaystackUser? paystackUser;

  CoreProfile({
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.gender,
    this.email,
    this.phoneNumber,
    this.profilePics,
    this.bio,
    this.meet,
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
    this.geography,
    this.faceVerification,
    this.updatedPhoto,
    this.currentPlan,
    this.paystackUser,
  });

  factory CoreProfile.fromJson(Map<String, dynamic> json) =>
      _$CoreProfileFromJson(json);

  Map<String, dynamic> toJson() => _$CoreProfileToJson(this);

  bool get premiumUser => isPremium ?? false;

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
        '  meet: $meet,\n'
        '  interests: ${interests?.join(", ") ?? "null"},\n'
        '  weight: $weight,\n'
        '  height: $height,\n'
        '  countryOfOrigin: $countryOfOrigin,\n'
        '  is_premium: $isPremium,\n'
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
        '  currentPlan: $currentPlan,\n'
        '  userSettings: ${userSettings.toString()},\n'
        '  amountPaid: ${amountPaid.toString()},\n'
        '  geography: ${geography?.toString() ?? "null"}\n'
        '  faceVerification: ${faceVerification?.toString() ?? "null"}\n'
        '  paystackUser: ${paystackUser?.toString() ?? "null"} \n' // Added this line
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CoreProfile &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.gender == gender &&
        //  other.phoneNumber == phoneNumber &&
        listEquals(other.profilePics, profilePics) &&
        other.bio == bio &&
        other.meet == meet &&
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
        other.paystackUser == paystackUser &&
        // other.geohash == geohash &&
        other.creditBalance == creditBalance &&
        other.amountPaid == amountPaid &&
        other.currentPlan == currentPlan &&
        other.userSettings == userSettings &&
        other.faceVerification == faceVerification;
  }

  @override
  int get hashCode {
    // Removed geohash
    return Object.hash(
      firstName,
      lastName,
      gender,
      // email,
      // phoneNumber,
      bio,
      meet,
      weight,
      height,
      isPremium,
      isApproved,
      isBanned,
      location,
      creditBalance,
      amountPaid,
      userSettings,
      faceVerification,
      currentPlan,
      paystackUser,
      Object.hashAll(profilePics ?? []),
      Object.hashAll(interests ?? []),
      Object.hashAll(blockedIds ?? []),
    );
  }
}
