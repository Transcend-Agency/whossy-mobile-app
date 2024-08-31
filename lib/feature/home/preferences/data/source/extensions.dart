import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../common/utils/index.dart';
import '../../model/core_preferences.dart';
import '../../model/other_preferences.dart';

extension CorePreferencesExtension on CorePreferences {
  Map<String, dynamic> diff(CorePreferences other) {
    final Map<String, dynamic> updatedFields = {};

    if (relationshipPreference != other.relationshipPreference) {
      updatedFields['preference'] = enumToIndex(relationshipPreference);
    }
    if (education != other.education) {
      updatedFields['education'] = enumToIndex(education);
    }
    if (loveLanguage != other.loveLanguage) {
      updatedFields['love_language'] = enumToIndex(loveLanguage);
    }
    if (zodiac != other.zodiac) {
      updatedFields['zodiac'] = enumToIndex(zodiac);
    }
    if (futureFamilyPlans != other.futureFamilyPlans) {
      updatedFields['family_plans'] = enumToIndex(futureFamilyPlans);
    }
    if (communicationStyle != other.communicationStyle) {
      updatedFields['communication_style'] = enumToIndex(communicationStyle);
    }
    if (smoker != other.smoker) {
      updatedFields['smoke'] = enumToIndex(smoker);
    }
    if (drinking != other.drinking) {
      updatedFields['drink'] = enumToIndex(drinking);
    }
    if (workout != other.workout) {
      updatedFields['workout'] = enumToIndex(workout);
    }
    if (petOwner != other.petOwner) {
      updatedFields['pet_owner'] = enumToIndex(petOwner);
    }
    if (religion != other.religion) {
      updatedFields['religion'] = enumToIndex(religion);
    }
    if (dietary != other.dietary) {
      updatedFields['dietary'] = enumToIndex(dietary);
    }
    if (maritalStatus != other.maritalStatus) {
      updatedFields['marital_status'] = enumToIndex(maritalStatus);
    }

    return updatedFields;
  }
}

extension OtherPreferencesExtension on OtherPreferences {
  Map<String, dynamic> diff(OtherPreferences other) {
    final Map<String, dynamic> updatedFields = {};

    if (meet != other.meet) {
      updatedFields['meet'] = meet;
    }
    if (similarInterest != other.similarInterest) {
      updatedFields['similar_interest'] = similarInterest;
    }
    if (hasBio != other.hasBio) {
      updatedFields['has_bio'] = hasBio;
    }
    if (!mapEquals(ageRange, other.ageRange)) {
      updatedFields['age_range'] = ageRange;
    }
    if (!AppUtils.areListsEqual(interests, other.interests)) {
      updatedFields['interests'] = interests;
    }
    if (distance != other.distance) {
      updatedFields['distance'] = distance;
    }
    if (outreach != other.outreach) {
      updatedFields['outreach'] = outreach;
    }
    if (country != other.country) {
      updatedFields['country'] = country;
    }
    if (city != other.city) {
      updatedFields['city'] = city;
    }
    if (!mapEquals(heightRange, other.heightRange)) {
      updatedFields['height_range'] = heightRange;
    }
    if (!mapEquals(weightRange, other.weightRange)) {
      updatedFields['weight_range'] = weightRange;
    }

    return updatedFields;
  }
}

extension RangeValuesExtension1 on Map<String, int>? {
  RangeValues? toRangeValues() {
    final min = this?['min'];
    final max = this?['max'];
    if (min == null || max == null) {
      return null;
    }
    return RangeValues(min.toDouble(), max.toDouble());
  }

  String displayRange({RangeType type = RangeType.height}) {
    String convertToFeetInches(int cm) {
      final totalInches = (cm / 2.54).round();
      final feet = totalInches ~/ 12;
      final inches = totalInches % 12;
      return "$feet'$inches\"";
    }

    String convertKgToPounds(int kg) {
      final pounds = (kg * 2.20462).round(); // Convert kg to pounds
      return '$pounds lbs';
    }

    if (this?['min'] == null || this?['max'] == null) {
      return 'Choose';
    }

    final minValue = this!['min'];
    final maxValue = this!['max'];

    return type == RangeType.height
        ? '${convertToFeetInches(minValue!)} - ${convertToFeetInches(maxValue!)}'
        : type == RangeType.weight
            ? '${convertKgToPounds(minValue!)} - ${convertKgToPounds(maxValue!)}'
            : 'Invalid type';
  }
}

extension RangeValuesExtension2 on RangeValues {
  String getFormattedRange({RangeType type = RangeType.height}) {
    String convertCmToInches(double cm) {
      final totalInches = (cm / 2.54).round();
      final feet = totalInches ~/ 12;
      final inches = totalInches % 12;
      return "$feet'$inches\"";
    }

    String convertKgToPounds(double kg) {
      final pounds = (kg * 2.20462).round();
      return '$pounds lbs';
    }

    final minValue = start.round();
    final maxValue = end.round();

    if (type == RangeType.height) {
      final minHeightInches = convertCmToInches(start);
      final maxHeightInches = convertCmToInches(end);
      return '${minValue}cm ($minHeightInches) - ${maxValue}cm ($maxHeightInches)';
    } else if (type == RangeType.weight) {
      final minWeightLbs = convertKgToPounds(start);
      final maxWeightLbs = convertKgToPounds(end);
      return '${minValue}kg ($minWeightLbs) - ${maxValue}kg ($maxWeightLbs)';
    } else {
      return 'Invalid type';
    }
  }
}
