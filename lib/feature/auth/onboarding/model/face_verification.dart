import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../common/utils/utils.dart';

part 'face_verification.g.dart';

@JsonSerializable()
class FaceVerification {
  @JsonKey(name: 'photo')
  String? photo;

  @JsonKey(
    name: 'updated_at',
    toJson: AppUtils.timestampToJson,
    fromJson: AppUtils.timestampFromJson,
  )
  Timestamp? updatedAt;

  @JsonKey(name: 'retake_photo')
  bool? retakePhoto;

  FaceVerification({
    this.photo, // Directly use this.photo instead of verificationPic
    this.updatedAt,
    this.retakePhoto = false,
  });

  factory FaceVerification.fromJson(Map<String, dynamic> json) =>
      _$FaceVerificationFromJson(json);

  Map<String, dynamic> toJson() => _$FaceVerificationToJson(this);

  // Convert from JSON
  static FaceVerification? faceVerificationFromJson(
      Map<String, dynamic>? json) {
    if (json == null) return FaceVerification();
    return FaceVerification.fromJson(json);
  }

  // Convert to JSON
  static Map<String, dynamic>? faceVerificationToJson(
      FaceVerification? faceVerification) {
    return faceVerification?.toJson();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FaceVerification &&
        other.photo == photo &&
        other.updatedAt == updatedAt &&
        other.retakePhoto == retakePhoto;
  }

  @override
  int get hashCode {
    return Object.hash(photo, updatedAt, retakePhoto);
  }

// Method to get the FaceVerification status
  FaceVerificationStatus getVerificationStatus() {
    if (photo == null) {
      return FaceVerificationStatus.notComplete;
    }
    if (retakePhoto == true) {
      return FaceVerificationStatus
          .notCompleteAndDeclined; // Photo exists, but retake is true
    }
    return FaceVerificationStatus.complete; // Photo exists, retake is false
  }

  @override
  String toString() {
    return 'FaceVerification(\n'
        '     photo: $photo,\n'
        '     updatedAt: ${updatedAt != null ? AppUtils.timestampToJson(updatedAt) : "null"},\n'
        '     retakePhoto: $retakePhoto\n'
        ' )';
  }
}
