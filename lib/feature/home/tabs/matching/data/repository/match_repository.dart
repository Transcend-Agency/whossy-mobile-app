import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:whossy_app/feature/home/tabs/matching/model/user_profile.dart';

import '../../../../../../common/utils/index.dart';

class MatchRepository {
  final _profiles = FirebaseFirestore.instance.collection('users');
  final _geo = GeoFlutterFire();

  Future<Map<String, dynamic>> fetchProfiles({
    int limit = 10,
    double radiusInKm = 300,
    DocumentSnapshot? lastDoc,
    double? longitude,
    double? latitude,
    required List<String> blockedIds,
  }) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    log("Fetching profiles...");
    log("Current User ID: $uid");

    log("Latitude: $latitude, Longitude: $longitude");

    // Check if latitude or longitude is null
    if (latitude == null || longitude == null) {
      log("Latitude or longitude is null. Returning empty list.");
      return {
        'profiles': <UserProfile>[],
        'lastDoc': lastDoc,
      };
    }

    // location
    final center = _geo.point(latitude: 6.5404938, longitude: 3.3554442);
    log("GeoPoint created: ${center.data}");

    var query = _geo
        .collection(
          collectionRef: _profiles,
        )
        .within(
          center: center,
          radius: radiusInKm,
          field: 'location',
          strictMode: true,
        );

    log("Query initialized. Fetching documents...");

    final List<UserProfile> userProfiles = [];

    try {
      // Using a for loop instead of forEach
      await for (var documentSnapshots in query) {
        if (documentSnapshots.isEmpty) {
          return {
            'profiles': userProfiles,
            'lastDoc': lastDoc,
          };
        }

        // Log raw data for debugging
        log("Raw data from Firestore: ${documentSnapshots.map((doc) => doc.data()).toList()}");

        for (var doc in documentSnapshots) {
          // Log the data for the current document
          log("Processing document: ${doc.id}");
          log("Document data: ${doc.data()}");

          final profile =
              UserProfile.fromJson(doc.data() as Map<String, dynamic>);

          if (!AppUtils.shouldExcludeProfile(profile, uid, blockedIds)) {
            userProfiles.add(profile);
          }
        }
      }
    } catch (e) {
      log("Error fetching profiles: $e");
    }

    return {
      'profiles': userProfiles,
      'lastDoc': lastDoc,
    };
  }
}
