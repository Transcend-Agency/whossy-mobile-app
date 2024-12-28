import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../preferences/model/other_preferences.dart';

class QueryHelper {
  static Map<String, dynamic> buildFilters(OtherPreferences preferences) {
    final filters = <String, dynamic>{
      if (preferences.meet != null) 'meet': preferences.meet!,
      if (preferences.ageRange != null) ...{
        'age_min': preferences.ageRange!['min'],
        'age_max': preferences.ageRange!['max'],
      },
      if (preferences.hasBio != null) 'hasBio': preferences.hasBio!,
    };
    return filters;
  }

  static Query applyFilters(Map<String, dynamic> filters, Query query) {
    // Define a map of filter functions
    final filterFunctions = {
      'meet': _applyMeetFilter,
      'age_min': _applyAgeMinFilter,
      'age_max': _applyAgeMaxFilter,
      'hasBio': _applyHasBioFilter,
      // Add other filters here as needed, e.g., 'height', 'weight', 'interests', etc.
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

  // Filter function for 'meet' (gender preference)
  static Query _applyMeetFilter(Query query, dynamic value) {
    int meetValue = value is int ? value : 2; // Default to no restriction
    if (meetValue == 0) {
      query = query.where('gender', isEqualTo: 'Male');
    } else if (meetValue == 1) {
      query = query.where('gender', isEqualTo: 'Female');
    }
    return query;
  }

  // Filter function for 'age_min' (minimum age)
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

  // Filter function for 'age_max' (maximum age)
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

  // Filter function for 'hasBio'
  static Query _applyHasBioFilter(Query query, dynamic value) {
    if (value is bool && value) {
      query = query
          .where(
            'bio',
            isNotEqualTo: null,
          )
          .where(
            'bio',
            isNotEqualTo: '',
          );
    }
    // If hasBio is false, do not apply any filter
    return query;
  }

// Add more filter functions as needed for other filters (e.g., height, weight, interests)
}
