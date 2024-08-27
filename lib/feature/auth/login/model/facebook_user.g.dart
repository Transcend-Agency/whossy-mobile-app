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

Map<String, dynamic> _$FacebookUserToJson(FacebookUser instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('userId', instance.userId);
  writeNotNull('email', instance.email);
  writeNotNull('avatar', instance.avatar);
  writeNotNull('firstName', instance.firstName);
  writeNotNull('token', instance.token);
  writeNotNull('loginType', instance.loginType);
  writeNotNull('isFacebook', instance.isFacebook);
  return val;
}
