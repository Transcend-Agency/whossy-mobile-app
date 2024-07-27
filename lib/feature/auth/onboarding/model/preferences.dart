import 'dart:io';

class Preferences {
  String? relationshipPref;
  String? meet;
  DateTime? dateOfBirth;
  int? search;
  List<String>? ticks;
  String? education;
  String? drink;
  String? smoker;
  List<String>? pets;
  String? workOut;
  String? bio;
  List<File>? profilePics;

  Preferences({
    this.relationshipPref,
    this.meet,
    this.dateOfBirth,
    this.search,
    this.ticks,
    this.education,
    this.drink,
    this.smoker,
    this.pets,
    this.workOut,
    this.bio,
    this.profilePics,
  });

  void update({
    String? relationshipPref,
    String? meet,
    DateTime? dateOfBirth,
    int? search,
    List<String>? ticks,
    String? education,
    String? drink,
    String? smoker,
    List<String>? pets,
    String? workOut,
    String? bio,
    List<File>? profilePics,
  }) {
    if (relationshipPref != null) this.relationshipPref = relationshipPref;
    if (meet != null) this.meet = meet;
    if (dateOfBirth != null) this.dateOfBirth = dateOfBirth;
    if (search != null) this.search = search;
    if (ticks != null) this.ticks = ticks;
    if (education != null) this.education = education;
    if (drink != null) this.drink = drink;
    if (smoker != null) this.smoker = smoker;
    if (pets != null) this.pets = pets;
    if (workOut != null) this.workOut = workOut;
    if (bio != null) this.bio = bio;
    if (profilePics != null) this.profilePics = profilePics;
  }
}
