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

Map<String, dynamic> _$FaceVerificationToJson(FaceVerification instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('photo', instance.photo);
  writeNotNull('updated_at', AppUtils.timestampToJson(instance.updatedAt));
  writeNotNull('retake_photo', instance.retakePhoto);
  return val;
}
