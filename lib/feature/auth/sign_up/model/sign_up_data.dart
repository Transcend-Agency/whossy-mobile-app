class SignUpData {
  String? email;
  String? firstName;
  String? lastName;
  String? phone;
  String? country;
  String? gender;

  SignUpData({
    this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.country,
    this.gender,
  });

  void update({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? country,
    String? gender,
  }) {
    if (email != null) this.email = email;
    if (firstName != null) this.firstName = firstName;
    if (lastName != null) this.lastName = lastName;
    if (phone != null) this.phone = phone;
    if (country != null) this.country = country;
    if (gender != null) this.gender = gender;
  }
}
