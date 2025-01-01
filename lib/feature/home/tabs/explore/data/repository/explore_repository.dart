import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../../common/utils/index.dart';
import '../../../../preferences/model/core_preferences.dart';
import '../../../../preferences/model/other_preferences.dart';
import '../../../matching/data/repository/query_helper.dart';
import '../../../matching/model/user_profile.dart';
import '../../model/explore_filters.dart';
import '../../model/filter_configuration.dart';

class ExploreRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _dislikes = FirebaseFirestore.instance.collection('dislikes');

  final excludeSettings = const ExcludeSettings(
    excludeIncompleteOnboarding: true,
    excludeBannedUsers: true,
    excludeUnapprovedUsers: true,
    excludeBlockedAndSelf: true,
  );

  Stream<List<UserProfile>> streamFilteredProfiles({
    required ExploreFilters filters,
    required List<String> blockedIds,
    required OtherPreferences? preferences,
    required CorePreferences? corePreferences,
    required List<String> interests,
  }) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    // Combine likes and dislikes into a single blacklist stream
    Stream<Set<String>> blacklistStream = Rx.combineLatest2(
      _likes.where('liker_id', isEqualTo: uid).snapshots().map(
            (snapshot) =>
                snapshot.docs.map((doc) => doc['liked_id'] as String).toSet(),
          ),
      _dislikes.where('disliker_id', isEqualTo: uid).snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => doc['disliked_id'] as String)
                .toSet(),
          ),
      (Set<String> likes, Set<String> dislikes) => likes.union(dislikes),
    );

    // Build the base query using filters
    Query baseQuery = _profiles;

    filters.filters.forEach((filter, value) {
      if (value != null && filterConfigs.containsKey(filter)) {
        baseQuery = filterConfigs[filter]!.apply(baseQuery, value);
      }
    });

    // Conditionally apply advanced search filters
    if (filters.filters.containsKey(Filters.advancedSearch)) {
      if (preferences != null || corePreferences != null) {
        baseQuery = QueryHelper.applyFilters(
          QueryHelper.buildFilters(
            preferences,
            corePreferences,
            userInterests: [
              ...interests,
              ...(preferences?.interests ?? []),
            ],
          ),
          baseQuery,
        );
      }
    }

    baseQuery = baseQuery.limit(20);

    // Combine profile snapshots with blacklist stream
    return Rx.combineLatest2(
      baseQuery.snapshots(),
      blacklistStream,
      (QuerySnapshot querySnapshot, Set<String> blacklist) {
        final profiles = querySnapshot.docs
            .map((doc) =>
                UserProfile.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        // Apply local filtering
        profiles.removeWhere((profile) =>
            AppUtils.excludeProfile(
              profile,
              uid,
              blockedIds,
              settings: excludeSettings,
            ) ||
            blacklist.contains(profile.user.uid));

        return profiles;
      },
    );
  }
}
