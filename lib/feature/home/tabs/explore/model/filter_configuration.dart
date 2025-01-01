import 'package:cloud_firestore/cloud_firestore.dart';

import 'explore_filters.dart';

class FilterConfig {
  final String firestoreKey;
  final dynamic Function(Query query, dynamic value) apply;

  const FilterConfig(this.firestoreKey, this.apply);
}

// Define filter configurations for each filter
final Map<Filters, FilterConfig> filterConfigs = {
  Filters.similarInterest: FilterConfig(
    'interests',
    (query, value) => query.where('interests', arrayContainsAny: value as List),
  ),
  Filters.online: FilterConfig(
    'status.online',
    (query, value) => query.where('status.online', isEqualTo: value),
  ),
  Filters.newMembers: FilterConfig(
    'created_at',
    (query, value) => query.where(
      'created_at',
      isGreaterThanOrEqualTo: Timestamp.fromDate(value as DateTime),
    ),
  ),
  Filters.outsideMyCountry: FilterConfig(
    'country_of_origin',
    (query, value) =>
        query.where('country_of_origin', isNotEqualTo: value as String),
  ),
  Filters.popularInMyArea: FilterConfig(
    'country_of_origin',
    (query, value) =>
        query.where('country_of_origin', isEqualTo: value as String),
  ),
  Filters.lookingToDate: FilterConfig(
    'preference',
    (query, value) => query.where('preference', isEqualTo: value as int),
  ),
  Filters.advancedSearch: FilterConfig(
    'uid',
    (query, value) => query,
  ),
};
