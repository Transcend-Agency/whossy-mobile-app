import 'dart:io';

class UserProfile {
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

  UserProfile({
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
}
