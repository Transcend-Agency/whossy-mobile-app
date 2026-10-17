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

  // Which verification_challenges doc was shown for this submission, and a
  // denormalized copy of its image so admin review stays stable even if the
  // challenge pool changes later. Written by the client; admin-only fields
  // below are written by the (Retool) admin tooling.
  @JsonKey(name: 'challenge_id')
  String? challengeId;

  @JsonKey(name: 'challenge_image_url')
  String? challengeImageUrl;

  // 'pending_review' | 'approved' | 'rejected'
  @JsonKey(name: 'status')
  String? status;

  @JsonKey(name: 'reviewed_by')
  String? reviewedBy;

  @JsonKey(
    name: 'reviewed_at',
    toJson: AppUtils.timestampToJson,
    fromJson: AppUtils.timestampFromJson,
  )
  Timestamp? reviewedAt;

  FaceVerification({
    this.photo, // Directly use this.photo instead of verificationPic
    this.updatedAt,
    this.retakePhoto = false,
    this.challengeId,
    this.challengeImageUrl,
    this.status,
    this.reviewedBy,
    this.reviewedAt,
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
        other.retakePhoto == retakePhoto &&
        other.challengeId == challengeId &&
        other.challengeImageUrl == challengeImageUrl &&
        other.status == status &&
        other.reviewedBy == reviewedBy &&
        other.reviewedAt == reviewedAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      photo,
      updatedAt,
      retakePhoto,
      challengeId,
      challengeImageUrl,
      status,
      reviewedBy,
      reviewedAt,
    );
  }

  // Method to get the FaceVerification status
  FaceVerificationStatus getVerificationStatus() {
    switch (status) {
      case 'approved':
        return FaceVerificationStatus.complete;
      case 'rejected':
        return FaceVerificationStatus.notCompleteAndDeclined;
      case 'pending_review':
        return FaceVerificationStatus.pending;
    }

    // Fallback for documents written before the `status` field existed.
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
        '     retakePhoto: $retakePhoto,\n'
        '     challengeId: $challengeId,\n'
        '     challengeImageUrl: $challengeImageUrl,\n'
        '     status: $status,\n'
        '     reviewedBy: $reviewedBy,\n'
        '     reviewedAt: ${reviewedAt != null ? AppUtils.timestampToJson(reviewedAt) : "null"}\n'
        ' )';
  }
}
