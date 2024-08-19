import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable(
  includeIfNull: false,
)
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

  final String? authProvider;

  @JsonKey(name: 'has_completed_account_creation')
  final bool hasCompletedAccountCreation;

  @JsonKey(name: 'has_completed_onboarding')
  final bool hasCompletedOnboarding;

  AppUser({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.phoneNumber,
    this.countryOfOrigin,
    this.authProvider,
    this.hasCompletedAccountCreation = false,
    this.hasCompletedOnboarding = false,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  Map<String, dynamic> toUpdateCreate() => {
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'phone_number': phoneNumber,
        'country_of_origin': countryOfOrigin,
        'authProvider': authProvider,
        'has_completed_account_creation': hasCompletedAccountCreation,
      };
}
