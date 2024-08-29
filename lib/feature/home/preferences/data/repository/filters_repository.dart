import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whossy_app/feature/home/preferences/model/other_preferences.dart';

import '../../../../../globals.dart';
import '../../model/core_preferences.dart';
import '../../model/filters.dart';

class PreferencesRepository {
  final _filtersFirestore = FirebaseFirestore.instance.collection('filters');

  Future<Filters?> fetchFilters() async {
    // final uid = FirebaseAuth.instance.currentUser!.uid;

    const uid = testId;

    final filtersSnapshot = await _filtersFirestore.doc(uid).get();

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
    // final uid = FirebaseAuth.instance.currentUser!.uid;

    const uid = testId;

    if (data != null) {
      await _filtersFirestore.doc(uid).set(data, SetOptions(merge: true));
    }
  }
}
