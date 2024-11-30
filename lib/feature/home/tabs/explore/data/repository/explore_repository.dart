import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../matching/model/user_profile.dart';
import '../../model/explore_filters.dart';
import '../../model/filter_configuration.dart';

class ExploreRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');

  Stream<List<UserProfile>> streamFilteredProfiles({
    required ExploreFilters filters,
  }) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Base query, ensuring profiles with 'uid' not equal to the current user
    Query query = _profiles.where('uid', isNotEqualTo: uid);

    query = query.where('has_completed_onboarding', isEqualTo: true);

    // Dynamically apply filters using FilterConfig
    filters.filters.forEach((filter, value) {
      if (value != null && filterConfigs.containsKey(filter)) {
        query = filterConfigs[filter]!.apply(query, value);
      }
    });

    query = query.limit(10);

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map(
              (doc) => UserProfile.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
