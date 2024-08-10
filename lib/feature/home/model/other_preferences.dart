class OtherPreferences {
  int? meet;
  bool? similarInterest;
  bool? hasBio;
  Map<String, int>? ageRange;
  List<String>? interests;
  double? distance;
  bool? outreach;

  OtherPreferences({
    this.meet,
    this.similarInterest,
    this.hasBio,
    this.ageRange,
    this.distance,
    this.interests,
    this.outreach,
  });

  void update({
    int? meet,
    bool? similarInterest,
    bool? hasBio,
    int? minAge,
    int? maxAge,
    double? distance,
    List<String>? interests,
    bool? outreach,
  }) {
    if (meet != null) this.meet = meet;
    if (similarInterest != null) this.similarInterest = similarInterest;
    if (hasBio != null) this.hasBio = hasBio;

    if (minAge != null || maxAge != null) {
      ageRange ??= {};
      if (minAge != null) ageRange!['minAge'] = minAge;
      if (maxAge != null) ageRange!['maxAge'] = maxAge;
    }

    if (distance != null) this.distance = distance;
    if (outreach != null) this.outreach = outreach;
    if (interests != null) this.interests = interests;
  }
}
