import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preferences.g.dart';

@JsonSerializable()
class Preferences {
  @JsonKey(name: 'preference')
  int? relationshipPref;

  @JsonKey(name: 'meet')
  int? meet;

  @JsonKey(
    name: 'date_of_birth',
    fromJson: _dateTimeFromJson,
    toJson: _dateTimeToJson,
  )
  DateTime? dateOfBirth;

  @JsonKey(name: 'distance')
  int? search;

  @JsonKey(name: 'interests')
  List<String>? ticks;

  @JsonKey(name: 'education')
  String? education;

  @JsonKey(name: 'drink')
  int? drink;

  @JsonKey(name: 'smoke')
  int? smoker;

  @JsonKey(name: 'pets')
  List<String>? pets;

  @JsonKey(name: 'workout')
  int? workOut;

  @JsonKey(name: 'bio')
  String? bio;

  @JsonKey(name: 'photos')
  List<String>? profilePics;

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