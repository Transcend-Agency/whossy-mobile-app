import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../../../common/utils/index.dart';
import '../../../../preferences/model/core_preferences.dart';
import '../../../../preferences/model/other_preferences.dart';
import '../../model/user_profile.dart';
import 'query_helper.dart';

class MatchRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');
  final _likes = FirebaseFirestore.instance.collection('likes');
  final _dislikes = FirebaseFirestore.instance.collection('dislikes');
  final _geo = GeoFlutterFire();
  final double radiusInKm = 50; // Default radius in kilometers

  final _matchFilterSettings = const ExcludeSettings(
    excludeIncompleteOnboarding: true,
    excludeBannedUsers: true,
    excludeUnapprovedUsers: true,
    excludeBlockedAndSelf: true,
  );

  Stream<List<UserProfile>> fetchProfilesStream({
    int limit = 20,
    double? longitude,
    double? latitude,
    required List<String> blockedIds,
    OtherPreferences? preferences,
    CorePreferences? corePreferences,
    required List<String> interests,
  }) async* {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (latitude == null || longitude == null) {
      yield [];
      return;
    }

    // Adjust radius based on distance preference (convert miles to km)
    double radius = radiusInKm;
    if (preferences?.distance != null) {
      radius = preferences!.distance!.toDouble();
    }

    if (preferences?.outreach != null) {
      if (preferences!.outreach ?? false) radius = 300;
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

    // Geolocation query with buffer radius
    var geoQuery = _geo
        .collection(collectionRef: _profiles)
        .within(center: center, radius: radius, field: 'geography');

    await for (var geoSnapshots in geoQuery) {
      List<UserProfile> userProfiles = [];

      if (geoSnapshots.isEmpty) {
        yield userProfiles;
        continue;
      }

      Query profilesQuery = _profiles;
      if (preferences != null || corePreferences != null) {
        profilesQuery = QueryHelper.applyFilters(
          QueryHelper.buildFilters(
            preferences,
            corePreferences,
            userInterests: [
              ...interests,
              ...(preferences?.interests ?? []),
            ],
          ),
          profilesQuery,
        );
      }

      // Match geolocation results with filtered profiles
      final filteredSnapshots = await profilesQuery.get();
      final filteredIds = filteredSnapshots.docs.map((doc) => doc.id).toSet();

      for (var doc in geoSnapshots) {
        if (doc.data() == null) continue;

        final profile =
            UserProfile.fromJson(doc.data() as Map<String, dynamic>);
        final data = doc.data() as Map<String, dynamic>;

        // Extract geopoint from the geography field
        final geopoint =
            (data['geography'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

        // Calculate the exact distance
        final distance = (Geolocator.distanceBetween(latitude, longitude,
                    geopoint.latitude, geopoint.longitude) /
                1000)
            .floor();

        if (!AppUtils.excludeProfile(
              profile,
              uid,
              blockedIds,
              settings: _matchFilterSettings,
            ) &&
            !blacklist.contains(profile.user.uid) &&
            filteredIds.contains(doc.id) &&
            radius.toInt() >= distance) {
          userProfiles.add(profile);
          if (userProfiles.length >= limit) break;
        }
      }

      yield userProfiles;
    }
  }
}
