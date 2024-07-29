import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preferences.g.dart';

@JsonSerializable()
class Preferences {
  @JsonKey(name: 'preference', includeIfNull: false)
  int? relationshipPref;

  @JsonKey(name: 'meet', includeIfNull: false)
  int? meet;

  @JsonKey(
      name: 'date_of_birth',
      fromJson: _dateTimeFromJson,
      toJson: _dateTimeToJson,
      includeIfNull: false)
  DateTime? dateOfBirth;

  @JsonKey(name: 'distance', includeIfNull: false)
  int? search;

  @JsonKey(name: 'interests', includeIfNull: false)
  List<String>? ticks;

  @JsonKey(name: 'education', includeIfNull: false)
  String? education;

  @JsonKey(name: 'drink', includeIfNull: false)
  int? drink;

  @JsonKey(name: 'smoke', includeIfNull: false)
  int? smoker;

  @JsonKey(name: 'pets', includeIfNull: false)
  List<String>? pets;

  @JsonKey(name: 'workout', includeIfNull: false)
  int? workOut;

  @JsonKey(name: 'bio', includeIfNull: false)
  String? bio;

  @JsonKey(name: 'photos', includeIfNull: false)
  List<String>? profilePics;

  @JsonKey(
    includeFromJson: false,
    includeToJson: false,
    includeIfNull: false,
  )
  List<File>? picFiles;

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
    this.picFiles,
  });

  void update({
    int? relationshipPref,
    int? meet,
    DateTime? dateOfBirth,
    int? search,
    List<String>? ticks,
    String? education,
    int? drink,
    int? smoker,
    List<String>? pets,
    int? workOut,
    String? bio,
    List<String>? profilePics,
    List<File>? picFiles,
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
    if (picFiles != null) this.picFiles = picFiles;
  }

  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$PreferencesToJson(this);

  // Custom fromJson method for dateOfBirth
  static DateTime? _dateTimeFromJson(dynamic json) {
    if (json is Timestamp) {
      return json.toDate();
    } else if (json is String) {
      return DateTime.parse(json);
    }
    return null;
  }

  // Custom toJson method for dateOfBirth
  static dynamic _dateTimeToJson(DateTime? date) {
    return date != null ? Timestamp.fromDate(date) : null;
  }
}
