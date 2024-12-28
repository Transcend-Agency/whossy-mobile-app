import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../../../../../common/utils/index.dart';
import '../../../../preferences/model/other_preferences.dart';
import 'query_helper.dart';

class MatchRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _dislikes = FirebaseFirestore.instance.collection('dislikes');
  final _geo = GeoFlutterFire();

  final _matchFilterSettings = const ExcludeSettings(
    excludeIncompleteOnboarding: true,
    excludeBannedUsers: true,
    excludeUnapprovedUsers: true,
    excludeBlockedAndSelf: true,
  );

  Stream<List<UserProfile>> fetchProfilesStream({
    int limit = 20,
    double radiusInKm = 300,
    double? longitude,
    double? latitude,
    required List<String> blockedIds,
    OtherPreferences? preferences,
  }) async* {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (latitude == null || longitude == null) {
      yield [];
      return;
    }

    final center = _geo.point(latitude: latitude, longitude: longitude);

    // Real-time listeners for likes and dislikes
    final blacklist = <String>{};

    _likes.where('liker_id', isEqualTo: uid).snapshots().listen(
      (snapshot) {
        blacklist.addAll(
          snapshot.docs.map((doc) => doc['liked_id'] as String),
        );
      },
    );

    _dislikes.where('disliker_id', isEqualTo: uid).snapshots().listen(
      (snapshot) {
        blacklist
            .addAll(snapshot.docs.map((doc) => doc['disliked_id'] as String));
      },
    );

    // Geolocation query
    var geoQuery = _geo
        .collection(collectionRef: _profiles)
        .within(center: center, radius: radiusInKm, field: 'geography');

    await for (var geoSnapshots in geoQuery) {
      List<UserProfile> userProfiles = [];

      if (geoSnapshots.isEmpty) {
        yield userProfiles;
        continue;
      }

      // Apply additional filters if provided
      Query profilesQuery = _profiles;
      if (preferences != null) {
        final filters = QueryHelper.buildFilters(preferences);
        log('The filters are $filters');
        profilesQuery = QueryHelper.applyFilters(filters, profilesQuery);
      }

      // Match geolocation results with filtered profiles
      final filteredSnapshots = await profilesQuery.get();
      final filteredIds = filteredSnapshots.docs.map((doc) => doc.id).toSet();

      for (var doc in geoSnapshots) {
        if (doc.data() == null) continue;

        final profile =
            UserProfile.fromJson(doc.data() as Map<String, dynamic>);
        if (!AppUtils.excludeProfile(
              profile,
              uid,
              blockedIds,
              settings: _matchFilterSettings,
            ) &&
            !blacklist.contains(profile.user.uid) &&
            filteredIds.contains(doc.id)) {
          userProfiles.add(profile);
          if (userProfiles.length >= limit) break;
        }
      }

      yield userProfiles;
    }
  }
}
