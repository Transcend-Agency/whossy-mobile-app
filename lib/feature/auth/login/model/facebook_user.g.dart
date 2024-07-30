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
      'userId': instance.userId,
      'email': instance.email,
      'avatar': instance.avatar,
      'firstName': instance.firstName,
      'token': instance.token,
      'loginType': instance.loginType,
      'isFacebook': instance.isFacebook,
    };
