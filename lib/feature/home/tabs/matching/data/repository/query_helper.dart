import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../common/utils/utils.dart';
import '../../../../preferences/model/core_preferences.dart';
import '../../../../preferences/model/other_preferences.dart';

class QueryHelper {
  static Map<String, dynamic> buildFilters(
    OtherPreferences? preferences,
    CorePreferences? corePreferences, {
    required List<String> userInterests,
  }) {
    final filters = <String, dynamic>{
      // OtherPreferences Filters
      if (preferences != null) ...{
        if (preferences.meet != null) 'meet': preferences.meet!,
        if (preferences.ageRange != null) ...{
          'age_min': preferences.ageRange!['min'],
          'age_max': preferences.ageRange!['max'],
        },
        if (preferences.hasBio != null) 'hasBio': preferences.hasBio!,
        if (preferences.similarInterest != null &&
            preferences.similarInterest! &&
            userInterests.isNotEmpty)
          'similar_interests': userInterests,
      },

      // CorePreferences Filters
      if (corePreferences != null) ...{
        if (corePreferences.relationshipPreference != null)
          'preference': corePreferences.relationshipPreference!,
        if (corePreferences.maritalStatus != null)
          'marital_status': corePreferences.maritalStatus!,
        if (corePreferences.education != null)
          'education': corePreferences.education!,
        if (corePreferences.loveLanguage != null)
          'love_language': corePreferences.loveLanguage!,
        if (corePreferences.zodiac != null) 'zodiac': corePreferences.zodiac!,
        if (corePreferences.smoker != null) 'smoke': corePreferences.smoker!,
        if (corePreferences.drinking != null)
          'drink': corePreferences.drinking!,
        if (corePreferences.workout != null)
          'workout': corePreferences.workout!,
        if (corePreferences.petOwner != null) 'pets': corePreferences.petOwner!,
        if (corePreferences.religion != null)
          'religion': corePreferences.religion!,
        if (corePreferences.dietary != null)
          'dietary': corePreferences.dietary!,
      }
    };

    log('The filters are $filters');
    return filters;
  }

  static Query applyFilters(Map<String, dynamic> filters, Query query) {
    final filterFunctions = {
      // Other filters
      'meet': _applyMeetFilter,
      'age_min': _applyAgeMinFilter,
      'age_max': _applyAgeMaxFilter,
      'hasBio': _applyHasBioFilter,
      'similar_interests': _applyInterestsFilter,

      // Core filters
      'preference': _applyRelationshipPreferenceFilter,
      'marital_status': _applyMaritalStatusFilter,
      'education': _applyEducationFilter,
      'love_language': _applyLoveLanguageFilter,
      'zodiac': _applyZodiacFilter,
      'smoke': _applySmokeFilter,
      'drink': _applyDrinkFilter,
      'workout': _applyWorkOutFilter,
      'pets': _applyPetOwnerFilter,
      'religion': _applyReligionFilter,
      'dietary': _applyDietaryFilter,
      'family_goal': _applyFutureFamilyPlansFilter,
      'communication_style': _applyCommunicationStyleFilter,
    };

    // Apply filters dynamically
    filters.forEach((key, value) {
      final filterFunction = filterFunctions[key];
      if (filterFunction != null) {
        query = filterFunction(query, value);
      }
    });

    return query;
  }

  static Query _applyMeetFilter(Query query, dynamic value) {
    int meetValue = value is int ? value : 2; // Default to no restriction
    if (meetValue == 0) {
      query = query.where('gender', isEqualTo: 'Male');
    } else if (meetValue == 1) {
      query = query.where('gender', isEqualTo: 'Female');
    }
    return query;
  }

  static Query _applyAgeMinFilter(Query query, dynamic value) {
    if (value is int) {
      DateTime now = DateTime.now();
      DateTime minAgeDate = DateTime(now.year - value, now.month, now.day);
      query = query.where(
        'date_of_birth',
        isLessThanOrEqualTo: Timestamp.fromDate(minAgeDate),
      );
    }
    return query;
  }

  static Query _applyAgeMaxFilter(Query query, dynamic value) {
    if (value is int) {
      DateTime now = DateTime.now();
      DateTime maxAgeDate = DateTime(now.year - value, now.month, now.day);
      query = query.where(
        'date_of_birth',
        isGreaterThanOrEqualTo: Timestamp.fromDate(maxAgeDate),
      );
    }
    return query;
  }

  static Query _applyHasBioFilter(Query query, dynamic value) {
    if (value is bool && value) {
      query =
          query.where('bio', isNotEqualTo: null).where('bio', isNotEqualTo: '');
    }
    // If hasBio is false, do not apply any filter
    return query;
  }

  static Query _applyInterestsFilter(Query query, dynamic value) {
    if (value is List<String> && value.isNotEmpty) {
      query = query.where('interests', arrayContainsAny: value);
    }
    return query;
  }

  static Query _applyRelationshipPreferenceFilter(Query query, dynamic value) {
    if (value is Preference) {
      query = query.where('preference', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applyMaritalStatusFilter(Query query, dynamic value) {
    if (value is MaritalStatus) {
      query = query.where('marital_status', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applyEducationFilter(Query query, dynamic value) {
    if (value is School) {
      query = query.where('education', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applyLoveLanguageFilter(Query query, dynamic value) {
    if (value is LoveLanguage) {
      query = query.where('love_language', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applyZodiacFilter(Query query, dynamic value) {
    if (value is Zodiac) {
      query = query.where('zodiac', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applySmokeFilter(Query query, dynamic value) {
    if (value is Smoke) {
      query = query.where('smoke', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applyDrinkFilter(Query query, dynamic value) {
    if (value is Drink) {
      query = query.where('drink', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applyWorkOutFilter(Query query, dynamic value) {
    if (value is WorkOut) {
      query = query.where('workout', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applyPetOwnerFilter(Query query, dynamic value) {
    if (value is PetOwner) {
      query = query.where('pets', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applyReligionFilter(Query query, dynamic value) {
    if (value is Religion) {
      query = query.where('religion', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applyDietaryFilter(Query query, dynamic value) {
    if (value is Dietary) {
      query = query.where('dietary', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applyFutureFamilyPlansFilter(Query query, dynamic value) {
    if (value is FutureFamilyPlans) {
      query = query.where('family_goal', isEqualTo: value.index);
    }
    return query;
  }

  static Query _applyCommunicationStyleFilter(Query query, dynamic value) {
    if (value is CommunicationStyle) {
      query = query.where('communication_style', isEqualTo: value.index);
    }
    return query;
  }
}
