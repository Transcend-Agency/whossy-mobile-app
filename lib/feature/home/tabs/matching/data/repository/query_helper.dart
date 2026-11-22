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

  /// Fields whose filter is a plain "equals this enum's index" check, exactly
  /// as the `_apply*Filter` functions below write them as queries.
  static const _enumEqualityFields = {
    'preference',
    'marital_status',
    'education',
    'love_language',
    'zodiac',
    'smoke',
    'drink',
    'workout',
    'pets',
    'religion',
    'dietary',
    'family_goal',
    'communication_style',
  };

  /// Client-side twin of [applyFilters]: true when the profile document
  /// [data] would be returned by a query built from the same [filters].
  ///
  /// Used for the swipe deck's "nearby" pass, which is a geohash query that
  /// can't also carry these filters server-side (it would need a composite
  /// index for every combination, and the age range is a second range
  /// filter Firestore won't combine with the geohash range).
  static bool matches(
    Map<String, dynamic> data,
    Map<String, dynamic> filters, {
    DateTime? now,
  }) {
    final today = now ?? DateTime.now();

    for (final entry in filters.entries) {
      final key = entry.key;
      final value = entry.value;

      switch (key) {
        case 'meet':
          final meet = value is int ? value : 2;
          if (meet == 0 && data['gender'] != 'Male') return false;
          if (meet == 1 && data['gender'] != 'Female') return false;
        case 'age_min':
          if (value is int) {
            final dob = _asDate(data['date_of_birth']);
            final latest = DateTime(today.year - value, today.month, today.day);
            if (dob == null || dob.isAfter(latest)) return false;
          }
        case 'age_max':
          if (value is int) {
            final dob = _asDate(data['date_of_birth']);
            if (dob == null || !dob.isAfter(_turnsAgeOn(today, value + 1))) {
              return false;
            }
          }
        case 'hasBio':
          if (value == true) {
            final bio = data['bio'];
            if (bio is! String || bio.isEmpty) return false;
          }
        case 'similar_interests':
          if (value is List<String> && value.isNotEmpty) {
            final theirs = data['interests'];
            if (theirs is! List || !theirs.any(value.contains)) return false;
          }
        default:
          if (_enumEqualityFields.contains(key) &&
              value is Enum &&
              data[key] != value.index) {
            return false;
          }
      }
    }
    return true;
  }

  /// Birth date of someone turning [age] on [today]. A maximum age of 30
  /// includes everyone born after the day people turning 31 today were
  /// born; the bound used to be the 30th birthday, which left out everyone
  /// in their last year of being 30.
  static DateTime _turnsAgeOn(DateTime today, int age) =>
      DateTime(today.year - age, today.month, today.day);

  static DateTime? _asDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    return null;
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
      // Born after the day someone turning value + 1 today was born, so
      // people who are [value] years and some months old are included.
      query = query.where(
        'date_of_birth',
        isGreaterThan: Timestamp.fromDate(
          _turnsAgeOn(DateTime.now(), value + 1),
        ),
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
