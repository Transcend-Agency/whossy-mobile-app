// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facebook_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FacebookUser _$FacebookUserFromJson(Map<String, dynamic> json) => FacebookUser(
      userId: json['userId'] as String?,
      email: json['email'] as String?,
      avatar: json['avatar'] as String?,
      firstName: json['firstName'] as String?,
      token: json['token'] as String?,
      loginType: json['loginType'] as String?,
      isFacebook: json['isFacebook'] as bool?,
    );

Map<String, dynamic> _$FacebookUserToJson(FacebookUser instance) =>
    <String, dynamic>{
      if (instance.userId case final value?) 'userId': value,
      if (instance.email case final value?) 'email': value,
      if (instance.avatar case final value?) 'avatar': value,
      if (instance.firstName case final value?) 'firstName': value,
      if (instance.token case final value?) 'token': value,
      if (instance.loginType case final value?) 'loginType': value,
      if (instance.isFacebook case final value?) 'isFacebook': value,
    };
