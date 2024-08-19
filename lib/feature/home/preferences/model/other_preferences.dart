import 'package:flutter/material.dart';
import 'package:whossy_mobile_app/common/utils/index.dart';

class OtherPreferences {
  int? meet;
  bool? similarInterest;
  bool? hasBio;
  Map<String, int>? ageRange;
  List<String>? interests;
  double? distance;
  bool? outreach;
  String? country;
  String? city;
  Map<String, int>? heightRange;
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
      // Handle weightRange
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
}
