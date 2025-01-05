import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../preferences/model/core_preferences.dart';
import '../../../../preferences/model/filters.dart';
import '../../../../preferences/model/other_preferences.dart';

class AdvancedSearchRepository {
  final _advancedSearchFirestore =
      FirebaseFirestore.instance.collection('advancedSearchPreferences');

  Future<Filters?> fetchFilters() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final filtersSnapshot = await _advancedSearchFirestore.doc(uid).get();

    if (filtersSnapshot.exists) {
      final data = filtersSnapshot.data();

      if (data != null) {
        return Filters(
          core: CorePreferences.fromJson(data),
          other: OtherPreferences.fromJson(data),
        );
      }
    }

    return null;
  }

  Future<void> updateFilters(Map<String, dynamic>? data) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    if (data != null) {
      await _advancedSearchFirestore
          .doc(uid)
          .set(data, SetOptions(merge: true));
    }
  }
}
