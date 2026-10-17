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
      challengeId: json['challenge_id'] as String?,
      challengeImageUrl: json['challenge_image_url'] as String?,
      status: json['status'] as String?,
      reviewedBy: json['reviewed_by'] as String?,
      reviewedAt: AppUtils.timestampFromJson(json['reviewed_at']),
    );

Map<String, dynamic> _$FaceVerificationToJson(FaceVerification instance) =>
    <String, dynamic>{
      if (instance.photo case final value?) 'photo': value,
      if (AppUtils.timestampToJson(instance.updatedAt) case final value?)
        'updated_at': value,
      if (instance.retakePhoto case final value?) 'retake_photo': value,
      if (instance.challengeId case final value?) 'challenge_id': value,
      if (instance.challengeImageUrl case final value?)
        'challenge_image_url': value,
      if (instance.status case final value?) 'status': value,
      if (instance.reviewedBy case final value?) 'reviewed_by': value,
      if (AppUtils.timestampToJson(instance.reviewedAt) case final value?)
        'reviewed_at': value,
    };
