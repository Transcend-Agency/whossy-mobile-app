import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:whossy_app/common/utils/index.dart';

import '../../model/preferences.dart';

class PreferenceRepository {
  final _prefFirestore = FirebaseFirestore.instance.collection('users');
  final _filtersFirestore = FirebaseFirestore.instance.collection('filters');

  final _deletePicQueue =
      FirebaseFirestore.instance.collection('deletePicQueue');

  Future<void> uploadFilters({required Map<String, dynamic> data}) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      // Check if the map contains 'meet' and 'distance' keys

      if (data.containsKeys(['meet', 'distance'])) {
        final filtersData = {
          'meet': data['meet'],
          'distance': data['distance'],
          'outreach': true,
          'has_bio': false,
          'age_range': {
            "max": 40,
            "min": 20,
          },
          'similar_interest': false,
        };

        // Update the 'filters' collection
        await _filtersFirestore
            .doc(uid)
            .set(filtersData, SetOptions(merge: true))
            .timeout(
              const Duration(seconds: 5),
              onTimeout: () => throw TimeoutException(
                  'The filters update operation timed out'),
            );
      }
    } on TimeoutException catch (e) {
      log("Timeout: ${e.message}");
    } catch (e) {
      rethrow;
    }
  }

  Future<Preferences?> getPreferences() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    final docSnapshot = await _prefFirestore.doc(uid).get();

    if (docSnapshot.exists) {
      final data = docSnapshot.data();

      if (data != null) return Preferences.fromJson(data);
    }

    return null;
  }

  Future<void> addDeletePicQueue() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      await _deletePicQueue
          .doc(uid)
          .set({"uid": uid}, SetOptions(merge: true)).timeout(
        const Duration(seconds: 5),
        onTimeout: () =>
            throw TimeoutException('The upload operation timed out'),
      );
    } on TimeoutException catch (e) {
      log("Timeout: ${e.message}");
    } catch (e) {
      rethrow;
    }
  }
}
