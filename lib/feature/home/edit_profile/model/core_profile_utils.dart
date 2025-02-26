part of 'core_profile.dart';

extension CoreProfileUtils on CoreProfile {
  void updateFromPreferences(Preferences prefs) {
    dateOfBirth = prefs.dateOfBirth ?? dateOfBirth;
    profilePics = prefs.profilePics ?? profilePics;
    bio = prefs.bio ?? bio;
    interests = prefs.ticks ?? interests;
    meet = prefs.meet ?? meet;
  }

  static List<String> transferKeys = ['photos', 'bio', 'interests'];

  Map<String, String?> getName() => {
        "firstName": firstName,
        "lastName": lastName,
      };

  dynamic getValue(String key) {
    if (!validKeys.contains(key)) {
      throw ArgumentError("Invalid key: $key");
    }

    final selectedValues = <String, dynamic>{
      "name": firstName,
      "birthday": DateFormat('MMMM d, y').format(dateOfBirth!),
      "gender": gender,
      "email": email,
      "phoneNumber": phoneNumber,
      "photoVerification": _getPhotoVerificationStatus(),
      "bio": bio,
      "full_name": {
        "firstName": firstName,
        "lastName": lastName,
      }
    };

    return selectedValues[key];
  }

  String _getPhotoVerificationStatus() {
    if (faceVerification?.getVerificationStatus() ==
            FaceVerificationStatus.complete &&
        !isApproved!) {
      return FaceVerificationStatus.pending.name;
    }
    return faceVerification!.getVerificationStatus().name;
  }

  void update({
    String? bio,
    String? gender,
    String? firstName,
    String? lastName,
    double? height,
    double? weight,
    int? creditBalance,
    List<String>? interests,
    List<String>? profilePics,
    List<String>? blockedIds,
    bool? isPremium,
    Payment? amountPaid,
    String? photoVerificationUrl,
    int? currentPlan,
  }) {
    if (bio != null) this.bio = bio;
    if (gender != null) this.gender = gender;
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = lastName;
    if (height != null) this.height = height;
    if (weight != null) this.weight = weight;
    if (isPremium != null) this.isPremium = isPremium;
    if (creditBalance != null) this.creditBalance = creditBalance;
    if (interests != null) this.interests = interests;
    if (profilePics != null) this.profilePics = profilePics;
    if (blockedIds != null) this.blockedIds = blockedIds;
    if (amountPaid != null) this.amountPaid = amountPaid;
    if (currentPlan != null) this.currentPlan = currentPlan;
    if (photoVerificationUrl != null) {
      faceVerification?.photo = photoVerificationUrl;
    }
  }

  void updateLocation({
    double? latitude,
    double? longitude,
    GeoPoint? location,
    String? geohash,
    Geography? geography,
  }) {
    if (latitude != null) this.latitude = latitude;
    if (longitude != null) this.longitude = longitude;
    if (location != null) this.location = location;
    if (geohash != null) this.geohash = geohash;
    if (geography != null) this.geography = geography;
  }

  bool get hasFullName => firstName != null && lastName != null;

  static const List<String> validKeys = [
    "name",
    "birthday",
    "gender",
    "email",
    "photoVerification",
    "phoneNumber",
    "bio",
    "full_name"
  ];
}
