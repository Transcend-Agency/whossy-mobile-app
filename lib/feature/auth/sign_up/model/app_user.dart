import 'package:json_annotation/json_annotation.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser {
  @JsonKey(name: 'uid', includeIfNull: false)
  final String? uid;

  @JsonKey(name: 'email', includeIfNull: false)
  final String? email;

  @JsonKey(name: 'first_name', includeIfNull: false)
  final String? firstName;

  @JsonKey(name: 'last_name', includeIfNull: false)
  final String? lastName;

  @JsonKey(name: 'gender', includeIfNull: false)
  final String? gender;

  @JsonKey(name: 'phone_number', includeIfNull: false)
  final String? phoneNumber;

  @JsonKey(name: 'country_of_origin', includeIfNull: false)
  final String? countryOfOrigin;

  @JsonKey(name: 'authProvider', includeIfNull: false)
  final String? authProvider;

  @JsonKey(name: 'has_completed_account_creation', includeIfNull: false)
  final bool hasCompletedAccountCreation;

  @JsonKey(name: 'has_completed_account_onboarding', includeIfNull: false)
  final bool hasCompletedAccountOnboarding;

  AppUser({
    this.uid,
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.phoneNumber,
    this.countryOfOrigin,
    this.authProvider,
    this.hasCompletedAccountCreation = false, // Default value
    this.hasCompletedAccountOnboarding = false, // Default value
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
