/// A reference pose/gesture shown to the user during selfie verification —
/// mirrors `verification_challenges/{id}` documents in Firestore. Plain
/// model (no json_serializable codegen needed for a shape this small).
class VerificationChallenge {
  final String id;
  final String imageUrl;
  final String label;

  VerificationChallenge({
    required this.id,
    required this.imageUrl,
    required this.label,
  });

  factory VerificationChallenge.fromJson(String id, Map<String, dynamic> json) {
    return VerificationChallenge(
      id: id,
      imageUrl: json['image_url'] as String,
      label: json['instruction'] as String? ?? '',
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is VerificationChallenge && other.id == id);

  @override
  int get hashCode => id.hashCode;
}
