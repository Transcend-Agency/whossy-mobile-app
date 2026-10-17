import 'package:json_annotation/json_annotation.dart';

part 'facebook_user.g.dart'; // This is required for the generated code

@JsonSerializable()
class FacebookUser {
  String? userId;
  String? email;
  String? avatar;
  String? firstName;
  String? token;
  String? loginType;
  bool? isFacebook;

  FacebookUser({
    this.userId,
    this.email,
    this.avatar,
    this.firstName,
    this.token,
    this.loginType,
    this.isFacebook,
  });

  // Factory constructor to create a UserModel instance from JSON
  factory FacebookUser.fromJson(Map<String, dynamic> json) =>
      _$FacebookUserFromJson(json);

  // Method to convert UserModel instance to JSON
  Map<String, dynamic> toJson() => _$FacebookUserToJson(this);
}
