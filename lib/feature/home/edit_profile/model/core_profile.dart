class CoreProfile {
  String? firstName;
  String? lastName;
  String? birthday; // Convert from date of birth
  String? gender;
  String? email;
  String? phoneNumber;
  List<String>? pictures;
  String? bio;
  List<String>? interests;

  // List of valid keys
  static const List<String> validKeys = [
    "name",
    "birthday",
    "gender",
    "email",
    "phoneNumber",
    "bio"
  ];

  CoreProfile({
    this.firstName,
    this.lastName,
    this.birthday,
    this.gender,
    this.email,
    this.phoneNumber,
    this.pictures,
    this.bio,
    this.interests,
  });

  Map<String, String?> getName() {
    return {"firstName": firstName, "lastName": lastName};
  }

  dynamic getValue(String key) {
    if (!validKeys.contains(key)) {
      throw ArgumentError("Invalid key: $key");
    }

    final selectedValues = <String, dynamic>{
      "name": firstName,
      "birthday": birthday,
      "gender": gender,
      "email": email,
      "phoneNumber": phoneNumber,
      "bio": bio,
    };

    return selectedValues[key];
  }

  void update({
    String? bio,
    List<String>? interests,
  }) {
    if (bio != null) this.bio = bio;
    if (interests != null) this.interests = interests;
  }
}
