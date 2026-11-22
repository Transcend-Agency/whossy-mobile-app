import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:whossy_app/common/utils/utils.dart';
import 'package:whossy_app/feature/home/preferences/data/source/extensions.dart';

part 'other_preferences.g.dart';

@JsonSerializable()
class OtherPreferences {
  int? meet;

  @JsonKey(name: "similar_interest")
  bool? similarInterest;

  @JsonKey(name: "has_bio")
  bool? hasBio;

  /// The age filter. It's on exactly when this is set: a null range means
  /// no age filter, which is also how older app versions read it.
  @JsonKey(name: "age_range")
  Map<String, int>? ageRange;

  /// The last age range chosen, kept while the filter is off so switching
  /// it back on restores it. The "In my age range" Explore filter uses it
  /// too (see [myAgeRange]).
  @JsonKey(name: "saved_age_range")
  Map<String, int>? savedAgeRange;

  List<String>? interests;
  int? distance;

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
    this.savedAgeRange,
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
    int? distance,
    List<String>? interests,
    String? country,
    String? city,
    bool? outreach,
    int? minHeight,
    int? maxHeight,
    int? minWeight,
    int? maxWeight,
  }) {
    this.meet = meet ?? this.meet;
    this.similarInterest = similarInterest ?? this.similarInterest;
    this.hasBio = hasBio ?? this.hasBio;

    if (minAge != null || maxAge != null) {
      ageRange ??= {};
      if (minAge != null) ageRange!['min'] = minAge;
      if (maxAge != null) ageRange!['max'] = maxAge;
      savedAgeRange = Map.of(ageRange!);
    }

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

    this.distance = distance ?? this.distance;
    this.interests = interests ?? this.interests;
    this.country = country ?? this.country;
    this.city = city ?? this.city;
    this.outreach = outreach ?? this.outreach;
  }

  /// Empties the chosen fields so the search stops filtering on them.
  void clear({
    bool country = false,
    bool city = false,
    bool height = false,
    bool weight = false,
  }) {
    if (country) this.country = null;
    if (city) this.city = null;
    if (height) heightRange = null;
    if (weight) weightRange = null;
  }

  bool get isAgeFilterOn => ageRange != null;

  /// The range "In my age range" in Explore uses: the active one, or the one
  /// chosen before the filter was switched off. Null when none was chosen.
  Map<String, int>? get myAgeRange => ageRange ?? savedAgeRange;

  /// Switches the age filter on (restoring the last range, or
  /// [startingRange] the first time) or off (keeping the range for later).
  void setAgeFilter(bool on, {required RangeValues startingRange}) {
    if (on) {
      final range = savedAgeRange ??
          {
            'min': startingRange.start.round(),
            'max': startingRange.end.round(),
          };
      ageRange = Map.of(range);
      savedAgeRange = Map.of(range);
    } else {
      if (ageRange != null) savedAgeRange = Map.of(ageRange!);
      ageRange = null;
    }
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
        '  savedAgeRange: $savedAgeRange,\n'
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
        mapEquals(other.savedAgeRange, savedAgeRange) &&
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
    return Object.hash(
      meet,
      similarInterest,
      hasBio,
      ageRange,
      savedAgeRange,
      interests,
      distance,
      outreach,
      country,
      city,
      heightRange,
      weightRange,
    );
  }
}
