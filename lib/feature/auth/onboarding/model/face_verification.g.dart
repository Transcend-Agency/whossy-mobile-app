// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'face_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FaceVerification _$FaceVerificationFromJson(Map<String, dynamic> json) =>
    FaceVerification(
      photo: json['photo'] as String?,
      updatedAt: AppUtils.timestampFromJson(json['updated_at']),
      retakePhoto: json['retake_photo'] as bool? ?? false,
    );

Map<String, dynamic> _$FaceVerificationToJson(FaceVerification instance) =>
    <String, dynamic>{
      if (instance.photo case final value?) 'photo': value,
      if (AppUtils.timestampToJson(instance.updatedAt) case final value?)
        'updated_at': value,
      if (instance.retakePhoto case final value?) 'retake_photo': value,
    };
