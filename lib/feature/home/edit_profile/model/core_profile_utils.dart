part of 'core_profile.dart';

extension CoreProfileUtils on CoreProfile {
  void updateFromPreferences(Preferences prefs) {
    dateOfBirth = prefs.dateOfBirth ?? dateOfBirth;
    profilePics = prefs.profilePics ?? profilePics;
    bio = prefs.bio ?? bio;
    interests = prefs.ticks ?? interests;
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
      "bio": bio,
      "full_name": {
        "firstName": firstName,
        "lastName": lastName,
      }
    };

    return selectedValues[key];
  }

  void update({
    String? bio,
    String? gender,
    String? firstName,
    String? lastName,
    double? height,
    double? weight,
    List<String>? interests,
    List<String>? profilePics,
    List<String>? blockedIds,
  }) {
    if (bio != null) this.bio = bio;
    if (gender != null) this.gender = gender;
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = lastName;
    if (height != null) this.height = height;
    if (weight != null) this.weight = weight;
    if (interests != null) this.interests = interests;
    if (profilePics != null) this.profilePics = profilePics;
    if (blockedIds != null) this.blockedIds = blockedIds;
  }

  bool get hasFullName => firstName != null && lastName != null;

  static const List<String> validKeys = [
    "name",
    "birthday",
    "gender",
    "email",
    "phoneNumber",
    "bio",
    "full_name"
  ];
}
