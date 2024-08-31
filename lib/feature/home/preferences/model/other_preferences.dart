import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whossy_app/common/utils/index.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';

part 'other_preferences.g.dart';

@JsonSerializable()
class OtherPreferences {
  int? meet;

  @JsonKey(name: "similar_interest")
  bool? similarInterest;

  @JsonKey(name: "has_bio")
  bool? hasBio;

  @JsonKey(name: "age_range")
  Map<String, int>? ageRange;

  List<String>? interests;
  double? distance;
  bool? outreach;
  String? country;
  String? city;

  @JsonKey(name: "height_range")
  Map<String, int>? heightRange;

  @JsonKey(name: "weight_range")
  Map<String, int>? weightRange;

  OtherPreferences({
    this.meet,
    this.similarInterest,
    this.hasBio,
    this.ageRange,
    this.distance,
    this.interests,
    this.outreach,
    this.heightRange,
    this.weightRange,
    this.country,
    this.city,
  });

  void update({
    int? meet,
    bool? similarInterest,
    bool? hasBio,
    int? minAge,
    int? maxAge,
    double? distance,
    List<String>? interests,
    String? country,
    String? city,
    bool? outreach,
    int? minHeight,
    int? maxHeight,
    int? minWeight,
    int? maxWeight,
  }) {
    if (meet != null) this.meet = meet;
    if (similarInterest != null) this.similarInterest = similarInterest;
    if (hasBio != null) this.hasBio = hasBio;

    if (minAge != null || maxAge != null) {
      ageRange ??= {};
      if (minAge != null) ageRange!['min'] = minAge;
      if (maxAge != null) ageRange!['max'] = maxAge;
    }

    if (distance != null) this.distance = distance;
    if (outreach != null) this.outreach = outreach;

    if (minHeight != null || maxHeight != null) {
      heightRange ??= {};
      if (minHeight != null) heightRange!['min'] = minHeight;
      if (maxHeight != null) heightRange!['max'] = maxHeight;
    }

    if (minWeight != null || maxWeight != null) {
      weightRange ??= {};
      if (minWeight != null) weightRange!['min'] = minWeight;
      if (maxWeight != null) weightRange!['max'] = maxWeight;
    }

    if (interests != null) this.interests = interests;
    if (country != null) this.country = country;
    if (city != null) this.city = city;
  }

  RangeValues? toAgeRange() => ageRange?.toRangeValues();
  RangeValues? toHeightRange() => heightRange?.toRangeValues();
  RangeValues? toWeightRange() => weightRange?.toRangeValues();

  factory OtherPreferences.fromJson(Map<String, dynamic> json) =>
      _$OtherPreferencesFromJson(json);

  Map<String, dynamic> toJson() => _$OtherPreferencesToJson(this);

  @override
  String toString() {
    return 'OtherPreferences(\n'
        '  meet: $meet,\n'
        '  similarInterest: $similarInterest,\n'
        '  hasBio: $hasBio,\n'
        '  ageRange: $ageRange,\n'
        '  interests: $interests,\n'
        '  distance: $distance,\n'
        '  outreach: $outreach,\n'
        '  country: $country,\n'
        '  city: $city,\n'
        '  heightRange: $heightRange,\n'
        '  weightRange: $weightRange\n'
        ')';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OtherPreferences &&
        other.meet == meet &&
        other.similarInterest == similarInterest &&
        other.hasBio == hasBio &&
        mapEquals(other.ageRange, ageRange) &&
        AppUtils.areListsEqual(other.interests, interests) &&
        other.distance == distance &&
        other.outreach == outreach &&
        other.country == country &&
        other.city == city &&
        mapEquals(other.heightRange, heightRange) &&
        mapEquals(other.weightRange, weightRange);
  }

  @override
  int get hashCode {
    return meet.hashCode ^
        similarInterest.hashCode ^
        hasBio.hashCode ^
        ageRange.hashCode ^
        interests.hashCode ^
        distance.hashCode ^
        outreach.hashCode ^
        country.hashCode ^
        city.hashCode ^
        heightRange.hashCode ^
        weightRange.hashCode;
  }
}
