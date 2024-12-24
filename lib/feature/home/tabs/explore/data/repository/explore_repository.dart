import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../../common/utils/index.dart';
import '../../../matching/model/user_profile.dart';
import '../../model/explore_filters.dart';
import '../../model/filter_configuration.dart';

class ExploreRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');

  Stream<List<UserProfile>> streamFilteredProfiles({
    required ExploreFilters filters,
    required List<String> blockedIds,
  }) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    Query query = _profiles
        .where('has_completed_onboarding', isEqualTo: true)
        .where('is_banned', isEqualTo: false)
        .where('is_approved', isEqualTo: true);

    filters.filters.forEach((filter, value) {
      if (value != null && filterConfigs.containsKey(filter)) {
        query = filterConfigs[filter]!.apply(query, value);
      }
    });

    query = query.limit(20);

    return query.snapshots().map((querySnapshot) {
      List<UserProfile> profiles = querySnapshot.docs
          .map(
              (doc) => UserProfile.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      // Apply local filtering using the helper method
      profiles.removeWhere((profile) => AppUtils.excludeProfile(
            profile,
            uid,
            blockedIds,
            settings: const ExcludeSettings(
              excludeIncompleteOnboarding: true,
              excludeBannedUsers: true,
              excludeUnapprovedUsers: true,
              excludeBlockedAndSelf: true,
            ),
          ));

      return profiles;
    });
  }
}
